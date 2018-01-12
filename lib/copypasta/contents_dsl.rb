module Copypasta
  class ContentsDSL
    attr_reader :contents
    attr_reader :directory

    def initialize(contents, directory)
      raise "contents must be a Copypasta::Contents" \
        unless contents.is_a?(Copypasta::Contents)

      raise "#{directory} doesn't exist." unless Dir.exist?(directory)

      @contents = contents
      @directory = directory
    end

    def create_even_if_empty!
      contents.force_create = true
    end

    def copy(filename, source: nil, only_if: nil)
      contents.entries << Copypasta::Entry::Copy.new(filename, directory: @directory, source: source, only_if: only_if).freeze
    end

    def erb(filename, source: nil, locals: {}, only_if: nil)
      contents.entries << Copypasta::Entry::ERB.new(filename, directory: @directory, source: source, locals: locals, only_if: only_if).freeze
    end

    def download(filename, source: nil, only_if: nil)
      contents.entries << Copypasta::Entry::Download.new(filename, source: source, only_if: only_if).freeze
    end

    def literal(filename, data:, only_if: nil)
      contents.entries << Copypasta::Entry::Literal.new(filename, data: data, only_if: only_if).freeze
    end
  end
end
