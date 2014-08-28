module ActiveStoreAccessor
  def active_store_attributes
    return @active_store_attributes if @active_store_attributes

    @active_store_attributes = superclass.respond_to?(:active_store_attributes) ? superclass.active_store_attributes : {}
  end

  def active_store_accessor(column_name, attrs)
    column = columns.detect { |column| column.name == column_name.to_s }
    if !column
      logger.warn("Column '#{column_name}' for active store accessor does not exist in model #{name}.")
      return
    elsif column.text?
      serialize(column_name) unless serialized_attributes.include?(column_name.to_s)
    end

    store_accessor column_name, *attrs.keys

    attrs.each do |attr_name, options|
      options = { type: options.to_s } unless options.is_a?(Hash)
      type = options.fetch(:type) { raise ArgumentError, "please specify type of `#{ attr_name }` attribute" }.to_s

      # time for activerecord is only a hours and minutes without date part
      # but for most rubist and rails developer it should contains a date too
      type = :datetime if type == :time

      args = [attr_name.to_s, options[:default], type]
      active_store_attributes[attr_name] = ActiveRecord::ConnectionAdapters::Column.new(*args)

      _active_store_accessor_module.module_eval <<-RUBY
        def #{ attr_name }
          column = self.class.active_store_attributes[:#{ attr_name }]
          value = column.type_cast(super)
          value.nil? ? column.default : value
        end

        def #{ attr_name }=(value)
          super self.class.active_store_attributes[:#{ attr_name }].type_cast_for_write(value)
        end
      RUBY
    end
  end

  private

  def _active_store_accessor_module
    @_active_store_accessor_module ||= begin
      mod = Module.new
      include mod
      mod
    end
  end
end

ActiveSupport.on_load(:active_record) { ActiveRecord::Base.extend(ActiveStoreAccessor) }
