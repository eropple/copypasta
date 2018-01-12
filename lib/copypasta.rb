require "copypasta/version"

require "copypasta/plan"

module Copypasta
  def self.apply(plan_directory:, destination_directory:,
                 parameters:,
                 interactive: false,
                 force: false)
    plan_directory = File.expand_path(plan_directory)
    destination_directory = File.expand_path(destination_directory)

    plan = Copypasta::Plan.from_directory(plan_directory)

    full_parameters =
      if interactive
        plan.interrogate(parameters)
      else
        parameters
      end

    plan.apply(full_parameters, destination_directory, force: force)
  end
end
