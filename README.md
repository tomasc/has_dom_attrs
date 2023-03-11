# HasDomAttrs

[![HasDomAttrs](https://github.com/tomasc/has_dom_attrs/actions/workflows/ruby.yml/badge.svg)](https://github.com/tomasc/has_dom_attrs/actions/workflows/ruby.yml)

Helper methods for dealing with html element attributes.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add has_dom_attrs

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install has_dom_attrs

## Usage

Include `HasDomAttrs` in your class:

```ruby
class Component
  include HasDomAttrs
end
```

This makes your component respond to `dom_attrs`, which returns a hash of class, data,
aria, and style attributes, that can be passed to Rails tag helpers.

```ruby
component = Component.new
tag.div "Hello world", **component.dom_attrs
```

You can define attributes using class methods:

```ruby
class DetailsComponent
  include HasDomAttrs

  has_dom_attr :open

  attr_reader :open

  def initialize(open: false)
    @open = open
  end
end
```

```ruby
component = Component.new(open: true)
component.dom_attrs
# => { open: "true" }
```

Likewise you can set classes, data, and aria attributes:

```ruby
class ModalComponent
  include HasDomAttrs

  has_dom_attr :open
  has_dom_class -> { "modal--width_#{width}" }
  has_dom_aria :aria_modal, if: :open
  has_dom_data :width

  attr_reader :open

  def initialize(open: false, width: :m)
    @open = open
    @width = width
  end
end
```

```ruby
component = ModalComponent.new(open: true, width: :l)
component.dom_attrs
# => { open: "true", class: "modal--width_l", aria: { modal: true }, data: { width: "l" } }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/has_dom_attrs.
