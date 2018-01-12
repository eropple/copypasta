parameter :required, "This parameter is required."

parameter :defaulted, "This integer parameter is required, but defaults to 5.",
          default: 5

parameter :list_of_ints, "Please provide a comma-separated list of integers.",
          postprocess: ->(raw) { raw.split(",").map(&:strip).map(&:to_i) }
