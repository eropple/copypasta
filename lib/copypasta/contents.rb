require "copypasta/entry"

require 'fileutils'

module Copypasta
  class Contents
    attr_reader :target_directory
    attr_accessor :force_create
    attr_reader :entries

    def initialize(target_directory)
      @target_directory = target_directory.dup.freeze
      @force_create = false
      @entries = []
    end

    def apply(root, parameters)
      content_dir = "#{root}/#{target_directory}"

      if should_create?
        FileUtils.mkdir_p content_dir
      end

      entries.each do |entry|
        entry.apply(content_dir, parameters)
      end
    end

    def should_create?
      force_create || !entries.empty?
    end

    def self.from_tree(root)
      require "copypasta/contents_dsl"

      raise "#{root} doesn't exist." unless Dir.exist?(root)
      root = File.expand_path(root)

      items = []

      Dir["#{root}/**/_contents.rb"].each do |f|
        f = File.expand_path(f)
        content_dir = File.dirname(f)
        target_directory = content_dir.sub(root, "").sub(%r!^/!, "")

        contents = Copypasta::Contents.new(target_directory)

        dsl = Copypasta::ContentsDSL.new(contents, content_dir)
        dsl.instance_eval File.read(f), f

        items << contents unless contents.entries.empty?
      end

      items
    end
  end
end
