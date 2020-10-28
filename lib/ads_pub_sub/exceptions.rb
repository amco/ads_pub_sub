module AdsPubSub
  class MissingConfigValues < RuntimeError
    def initialize(missing_methods)
      @missing_methods = missing_methods.join(', ')
    end

    def to_s
      "#{@missing_methods} are missing from the config object"
    end
  end
end
