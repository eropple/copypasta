module Copypasta
  module Entry
    class Base
      attr_reader :filename

      def apply(destination_directory, parameters)
        do_apply(destination_directory, parameters) \
          if @only_if.nil? || @only_if.call(parameters)
      end

      private

      def do_apply(_destination_directory, _parameters)
        raise "#{self.class.name}#do_apply(destination_directory, parameters) must be implemented."
      end

      def target_file(destination_directory)
        "#{destination_directory}/#{@filename}"
      end
    end
  end
end
