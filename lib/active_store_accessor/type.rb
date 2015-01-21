module ActiveStoreAccessor
  class Type
    def initialize(from, to, default)
      @from = from
      @to = to
      @default = default
    end

    def from_store(value)
      result = @from.call(value)
      result.nil? ? @default : result
    end

    def to_store(value)
      @to.call(value)
    end
  end
end
