require "copypasta/entry/base"

require "uri"

module Copypasta
  module Entry
    class Download < Copypasta::Entry::Base
      attr_reader :source

      def initialize(filename, source:, only_if: nil)
        raise "filename must be a string." unless filename.is_a?(String)
        raise "source url '#{source}' looks invalid." \
          unless source =~ URI::DEFAULT_PARSER.make_regexp
        raise "only_if must be null or a Proc." if !only_if.nil? && !only_if.is_a?(Proc)

        @filename = filename
        @source = source
        @only_if = only_if
      end

      private

      def do_apply(destination, _parameters)
        require "open-uri"

        download = open(@source)
        IO.copy_stream(download, target_file(destination))
      end
    end
  end
end
