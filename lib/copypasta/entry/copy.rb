require "copypasta/entry/base"

require "fileutils"

module Copypasta
  module Entry
    class Copy < Copypasta::Entry::Base
      attr_reader :source

      def initialize(filename, directory:, source: nil, only_if: nil)
        raise "filename must be a string." unless filename.is_a?(String)
        raise "only_if must be null or a Proc." if !only_if.nil? && !only_if.is_a?(Proc)

        @filename = filename
        @directory = directory
        @only_if = only_if

        @source = source || filename
      end

      private

      def do_apply(destination, _parameters)
        FileUtils.cp("#{@directory}/#{@source}", target_file(destination))
      end
    end
  end
end
