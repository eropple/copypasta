require "copypasta/entry/base"

require "tilt/erb"

module Copypasta
  module Entry
    class ERB < Copypasta::Entry::Base
      attr_reader :source
      attr_reader :locals

      def initialize(filename, directory:, locals: {}, source: nil, only_if: nil)
        raise "filename must be a string." unless filename.is_a?(String)
        raise "only_if must be null or a Proc." if !only_if.nil? && !only_if.is_a?(Proc)
        raise "locals must be a Hash." unless locals.is_a?(Hash)

        @filename = filename.dup.freeze
        @directory = directory.dup.freeze
        @locals = locals.dup.freeze
        @source = (source || "#{filename}.erb").dup.freeze
        @only_if = only_if
      end

      private

      def do_apply(destination, parameters)
        template = Tilt::ERBTemplate.new("#{@directory}/#{@source}")
        output = template.render(Object.new, @locals.merge(parameters: parameters))

        IO.write(target_file(destination), output)
      end
    end
  end
end
