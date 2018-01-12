module Copypasta
  class ParameterDefinition
    attr_reader :name
    attr_reader :description
    attr_reader :default
    attr_reader :postprocess

    def initialize(name, description, default, postprocess)
      raise "name must be nil or a Symbol." \
        unless name.is_a?(Symbol) || name.nil?
      @name = name

      raise "description must be nil or a String." \
        unless description.is_a?(String) || description.nil?
      @description = description

      @default = default

      raise "postprocess must be nil or a String." \
        unless postprocess.is_a?(Proc) || postprocess.nil?
      @postprocess = postprocess
    end
  end
end
