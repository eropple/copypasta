require "copypasta/settings"
require "copypasta/contents"

module Copypasta
  class Plan
    attr_reader :root
    attr_reader :settings
    attr_reader :contents

    def initialize(settings:, contents: [])
      raise "settings must be a Copypasta::Settings" \
        unless settings.is_a?(Copypasta::Settings)

      raise "'contents' must be an Array of Copypasta::Contents." \
        unless contents.is_a?(Array) && contents.all? { |c| c.is_a?(Copypasta::Contents) }

      @settings = settings.dup.freeze
      @contents = contents.dup.freeze
    end

    def interrogate(parameters)
      raise "#interrogate can only be called when STDOUT is a tty?." \
        unless STDOUT.tty?
      # TODO: check to see if the parameter exists; if it doesn't, ask on the
      #       tty for a value.
      # TODO: decide whether to notify-and-retry or fail on invalid parameter.

      require "highline"
      cli = HighLine.new

      missing_parameters =
        settings.parameter_definitions
                .values.select { |pd| parameters[pd.name].nil? }

      missing_parameters.each do |pd|
        puts pd.description
        answer = cli.ask("#{pd.name}: ") { |q| q.default = pd.default }

        answer = pd.postprocess.call(answer) unless pd.postprocess.nil?

        puts "Received parameter '#{pd.name}': '#{answer}'"

        parameters[pd.name] = answer
      end

      parameters
    end

    def parameters_valid?(parameters)
      ret = @settings.validate(parameters)

      ret.all?(&:empty?)
    end

    def apply(parameters, destination_directory, force: false)
      # TODO: validate the parameters, then call all of the entries with the
      #       parameter set

      raise "parameter set is invalid, check the logs." \
        unless parameters_valid?(parameters)
      raise "Directory is dirty. Use force to create anyway." \
        if !force && !directory_clean?(destination_directory)

      contents.each { |c| c.apply(destination_directory, parameters) }
    end

    def self.from_directory(root)
      raise "#{root} doesn't exist." unless Dir.exist?(root)
      root = File.expand_path(root)

      settings = Copypasta::Settings.from_file("#{root}/_settings.rb")
      contents = Copypasta::Contents.from_tree(root)

      Copypasta::Plan.new(settings: settings, contents: contents)
    end

    private

    def directory_clean?(destination)
      Dir["#{destination}/*"].reject { |f| f == ".." || f == "." }.empty?
    end
  end
end
