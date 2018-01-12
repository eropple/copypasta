require "yaml"
require "json"

require "dry/validation"

require "copypasta/settings"
require "copypasta/parameter_definition"

module Copypasta
  class SettingsDSL
    attr_reader :settings

    def initialize(settings = nil)
      raise "settings must be a Copypasta::Settings." \
        if !settings.nil? && !settings.is_a?(Copypasta::Settings)

      @settings = settings || Copypasta::Settings.new
    end

    def parameter(name, description, default: nil, postprocess: nil)
      name = name.to_sym
      raise "Duplicate parameter '#{name}' detected." \
        if settings.parameter_definitions.key?(name)

      param = Copypasta::ParameterDefinition.new(name, description,
                                                 default,
                                                 postprocess)
      param.freeze

      settings.parameter_definitions[name] = param
    end

    def yaml(name, description)
      parameter(name, description,
                postprocess: ->(raw) {
                  if raw.is_a?(String)
                    raw
                  else
                    YAML.safe_load(raw)
                  end
                })
    end

    def json(name, description)
      parameter(name, description,
                postprocess: ->(raw) {
                  if raw.is_a?(String)
                    raw
                  else
                    JSON.parse(raw)
                  end
                })
    end

    def csv(name, description, postprocess: nil)
      parameter(name, description,
                postprocess: ->(raw) {
                  r = raw.split(",").map(&:strip)
                  if postprocess
                    postprocess.call(r)
                  else
                    r
                  end
                })
    end
  end
end
