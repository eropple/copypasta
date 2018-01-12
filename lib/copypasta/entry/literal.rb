require "copypasta/entry/base"

module Copypasta
  module Entry
    class Literal < Copypasta::Entry::Base
      attr_reader :data

      def initialize(filename, data:, only_if: nil)
        raise "filename must be a string." unless filename.is_a?(String)
        raise "only_if must be null or a Proc." if !only_if.nil? && !only_if.is_a?(Proc)

        @filename = filename
        @data = data
        @only_if = only_if
      end

      private

      def do_apply(destination, _parameters)
        IO.write(target_file(destination), data.to_s)
      end
    end
  end
end
