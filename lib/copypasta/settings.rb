require "dry/validation"

require "copypasta/parameter_definition"

module Copypasta
  class Settings
    attr_reader :parameter_definitions

    def initialize
      @parameter_definitions = {}
    end

    def self.from_file(path)
      require "copypasta/settings_dsl"
      raise "#{path} doesn't exist." unless File.exist?(path)

      dsl = Copypasta::SettingsDSL.new
      dsl.instance_eval File.read(path), path
      dsl.settings
    end
  end
end
