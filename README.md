# Copypasta #
File generators are cool. Sometimes you need some scaffolding for things! But
unless you're using Thor (and Thor is also cool) or Rails (and Rails is not
cool), your options are pretty limited. Sometimes you can hack one together, in
an awkward way--shout out to anyone who's ever written a bunch of Chef!--but
there's no unified way that works on a CLI, embedded in your app, or in Chef.

So I decided to thereifixedit the whole thing.

Copypasta is tested primarily under Ruby 2.5. Feel free to file bugs for Ruby
2.3 or later.

## Usage ##
Copypasta works on the concept of a `Plan`. A `Plan` is a directory structure
that mimics the final data structure while offering a DSL that figures out what,
exactly, should be dropped into the directory. Each directory in your `Plan`
must have a `_contents.rb` file that will be evaluated with our shiny happy
Copypasta DSL. `_contents.rb` will define files that live in that directory and
how they should be built:

- `copy` files are copied directly over; by default, `copy 'foo.txt'` will look
  for a `foo.txt` at the same level as the `_contents.rb` file. You can specify
  a specific file with `source:`.
- `erb` files are processed via Erubi; by default, `erb 'foo.txt'` will look for
  a `foo.txt.erb` file. The plan's parameters will be passed to the erb file,
  but additional local variables can be specified with the `parameters:` option.
  You can specify a specific ERB template with `source:`.
- `download` fetches a file. `source:` is required.
- `literal` takes a Ruby string as `data:` and writes a file with the contents
  of that string out to disk.

All content entries support the following options:

- `only_if`: Takes a `lambda |parameters| {}`; if truthy, writes out the file.

The root of your `Plan` should also contain a `_settings.rb` file which will
describe what parameters should be passed into the `Plan`. These parameters can
be retrieved interrogatively or passed in as data.

### `_settings.rb` ###
- `parameter` declarations require a name (a `Symbol`) and a description (a
  `String`). They can take the following options:
  - `postprocess`: if interactively delivered, the string that comes out of
    HighLine will be run through the specified 1-arity `Proc`. The returned
    value will be stored in `parameters` as exposed to the runtime.

### `_contents.rb` ###

## Future Work/How You Can Help ##
- A Git handler for the `plan` content type would be a nice way to expand
  Copypasta's usability.
- Parameter validation, both per-parameter and at a higher level (combinations
  of parameters). The proper answer here is probably to use something like
  [dry-validation](https://github.com/dry-rb/dry-validation) that can accept
  Procs.

## Development ##

After checking out the repo, run `bin/setup` to install dependencies. You can
also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing ##

Bug reports and pull requests are welcome on GitHub at
https://github.com/eropple/copypasta. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License ##

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Copypasta project’s codebases, issue trackers, chat
rooms and mailing lists is expected to follow the [code of
conduct](https://github.com/eropple/copypasta/blob/master/CODE_OF_CONDUCT.md).
