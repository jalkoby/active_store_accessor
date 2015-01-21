module ActiveStoreAccessor
  class Builder
    DEFAULT_CASTER = lambda { |value| value }

    def initialize(names)
      @names = names
    end

    def from_source(caster = nil, &block)
      @from_source = caster || block
    end

    def to_source(caster = nil, &block)
      @to_source = caster || block
    end

    def to_type
      [@names, (@from_source || DEFAULT_CASTER), (@to_source || DEFAULT_CASTER)]
    end
  end
end
