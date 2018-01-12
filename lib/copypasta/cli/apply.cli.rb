usage "PATH_TO_PLAN [DESTINATION]"

flag :f, :force, "applies plan even to a non-empty directory"

run do |opts, args, cmd|
  unless (1..2).cover?(args.length)
    puts cmd.help
    exit 1
  end

  plan_directory = args[0]
  destination_directory = args[1] || "."

  require "copypasta"

  Copypasta.apply(plan_directory: plan_directory,
                  destination_directory: destination_directory,
                  parameters: {},
                  interactive: true,
                  force: opts[:force])
end
