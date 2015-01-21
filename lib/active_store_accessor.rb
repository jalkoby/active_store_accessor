require_relative "active_store_accessor/builder"
require_relative "active_store_accessor/rails"
require_relative "active_store_accessor/type"

module ActiveStoreAccessor
  extend self

  def types
    @types ||= []
  end

  def add_type(*names)
    raise_arg_error("You could use only symbols for name") if names.any? { |name| !name.is_a?(Symbol) }
    builder = Builder.new(names)
    yield builder
    types << builder.to_type
  end

  def find_type(name, options, model_name)
    raise_arg_error("Please use a symbol for a setting type in #{ model_name }.") unless name.is_a?(Symbol)
    type_args = types.detect { |type_args| type_args[0].include?(name) }
    unless type_args
      raise_arg_error("#{ name } is unknown. Please recheck a type's name or add it by `ActiveStoreAccessor.add_type`.")
    end
    Type.new(type_args[1], type_args[2], options[:default])
  end

  def raise_error(klass, message)
    raise klass, "[active_store_accessor] #{ message }"
  end

  def raise_arg_error(message)
    raise_error ArgumentError, message
  end

  def raise_convertion_error(value, type)
    raise_error klass, "ActiveStoreAccessor doesn't know how to convert #{ value.class } into #{ type }"
  end

  add_type(:integer) do |builder|
    builder.to_source { |value| value.to_i rescue nil }
  end

  add_type(:float, :double) do |builder|
    builder.to_source { |value| value.to_f unless value.nil? }
  end

  add_type(:decimal) do |builder|
    builder.from_source { |value| value.to_d unless value.nil? }

    builder.to_source do |value|
      if value.respond_to?(:to_d)
        value.to_d.to_s
      else
        value.to_s.presence
      end
    end
  end

  # time for activerecord is only a hours and minutes without date part
  # but for most rubist and rails developer it should contains a date too
  add_type(:time, :datetime) do |builder|
    builder.from_source { |value| Time.parse(value) if value }

    to_source = lambda do |value|
      return unless value.present?

      case value
      when String then Time.parse(value).to_s
      when Fixnum then Time.at(value).to_s
      when Date, Time, DateTime, ActiveSupport::TimeZone then value.to_s
      else
        raise_convertion_error(value, "Time")
      end
    end

    builder.to_source(to_source)
  end

  add_type(:date) do |builder|
    to_source = lambda do |value|
      return if value.nil?
      case value
      when String then Date.parse(value).to_s
      when Date then value.to_s
      when Time, DateTime then value.to_date.to_s
      else
        raise_convertion_error(value, "Date")
      end
    end

    builder.to_source(to_source)
  end

  add_type(:text, :string, :binary) do |builder|
    builder.to_source { |value| value.presence }
  end

  add_type(:boolean, :bool) do |builder|
    true_values = [true, 1, '1', 't', 'T', 'true', 'TRUE', 'on', 'ON'].to_set

    builder.to_source do |value|
      if value.nil? || (value.is_a?(String) && value.empty?)
        nil
      else
        true_values.include?(value)
      end
    end
  end

  add_type(:array, :list) do |builder|
    builder.to_source { |value| ActiveSupport::JSON.encode(Array(value)) unless value.nil? }
    builder.from_source { |value| ActiveSupport::JSON.decode(value) unless value.nil? }
  end

  add_type(:hash, :dictonary) do |builder|
    if RUBY_VERSION =~ /1\.9/
      builder.to_source do |value|
        value = if value.is_a?(Hash)
          value
        elsif value.respond_to?(:to_h)
          value.to_h
        elsif value.respond_to?(:to_hash)
          value.to_hash
        else
          raise_convertion_error(value, 'Hash')
        end
        ActiveSupport::JSON.encode(Hash(value)) unless value.nil?
      end
    else
      builder.to_source { |value| ActiveSupport::JSON.encode(Hash(value)) unless value.nil? }
    end
    builder.from_source { |value| ActiveSupport::JSON.decode(value) unless value.nil? }
  end
end

ActiveSupport.on_load(:active_record) { ActiveRecord::Base.extend(ActiveStoreAccessor::Rails) }
