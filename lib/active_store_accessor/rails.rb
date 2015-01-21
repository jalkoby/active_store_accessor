module ActiveStoreAccessor
  module Rails
    def active_store_attributes
      return @active_store_attributes if @active_store_attributes

      @active_store_attributes = superclass.respond_to?(:active_store_attributes) ? superclass.active_store_attributes : {}
    end

    def active_store_accessor(column_name, attrs)
      column = columns.detect { |column| column.name == column_name.to_s }
      if !column
        ::ActiveStoreAccessor.raise_arg_error "The column `#{ column_name }` does not exist in the model #{ name }."
      elsif column.type == :text
        serialize(column_name) unless serialized_attributes.include?(column_name.to_s)
      end

      store_accessor column_name, *attrs.keys

      attrs.each do |attr_name, options|
        options = { type: options } unless options.is_a?(Hash)

        type = options.fetch(:type) do
          ::ActiveStoreAccessor.raise_arg_error "Please specify the type of `#{ attr_name }` attribute."
        end

        active_store_attributes[attr_name] = ::ActiveStoreAccessor.find_type(type, options, name)

        _active_store_accessor_module.module_eval <<-RUBY
          def #{ attr_name }
            self.class.active_store_attributes.fetch(:#{ attr_name }).from_store(super)
          end

          def #{ attr_name }=(value)
            super self.class.active_store_attributes.fetch(:#{ attr_name }).to_store(value)
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
end
