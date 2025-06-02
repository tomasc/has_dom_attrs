# Claude Code Instructions for has_dom_attrs

## Project Overview

`has_dom_attrs` is a Ruby gem that provides helper methods for dealing with HTML element attributes in Ruby components. It allows developers to define DOM attributes, classes, data attributes, ARIA attributes, and inline styles in a declarative way.

## Key Concepts

- **HasDomAttrs Module**: The main module that gets included in classes to provide DOM attribute functionality
- **Class Methods**: `has_dom_attr`, `has_dom_class`, `has_dom_data`, `has_dom_aria`, `has_dom_style`
- **Instance Methods**: `dom_attrs`, `dom_classes`, `dom_data`, `dom_aria`, `dom_style`

## Development Guidelines

### Testing
- Run tests with: `bundle exec rake test`
- Tests are located in `test/has_dom_attrs_test.rb`
- Follow the existing test patterns when adding new features

### Code Style
- Ruby 3.3.4 is used (see `.ruby-version`)
- RuboCop is configured with Rails conventions
- Run linting with: `bundle exec rubocop`
- Auto-fix issues with: `bundle exec rubocop -A`

### Version Management
- Version is defined in `lib/has_dom_attrs/version.rb`
- Update CHANGELOG.md when making changes
- Follow semantic versioning

## Common Tasks

### Adding a New Attribute Type
1. Define the class method in `ClassMethods` module
2. Implement the prepend logic to handle the attribute
3. Add corresponding instance method if needed
4. Add tests to verify functionality
5. Update README.md with examples

### Modifying Existing Behavior
1. Check tests first to understand current behavior
2. Update implementation in `lib/has_dom_attrs.rb`
3. Update or add tests as needed
4. Ensure backward compatibility

### Key Implementation Details

- The gem uses `prepend` to dynamically add methods to classes
- Conditional rendering is supported via `:if` and `:unless` options
- Values can be static, method names (symbols), or Procs
- All keys are stringified and dasherized for HTML compatibility
- Empty values are filtered out from the final hash

## File Structure

```
├── lib/
│   ├── has_dom_attrs.rb          # Main implementation
│   └── has_dom_attrs/version.rb  # Version constant
├── test/
│   ├── has_dom_attrs_test.rb     # Test suite
│   └── test_helper.rb             # Test configuration
├── .rubocop.yml                   # Linting configuration
├── Gemfile                        # Dependencies
├── has_dom_attrs.gemspec          # Gem specification
└── README.md                      # User documentation
```

## Important Patterns

### Dynamic Method Definition
The gem uses metaprogramming to define methods dynamically:
```ruby
prepend(Module.new do
  define_method method_name do
    # Implementation
  end
end)
```

### Conditional Logic
Both `:if` and `:unless` options support:
- Symbols (method names)
- Strings (method names)
- Procs (evaluated in instance context)

### Value Resolution
Values are resolved in this order:
1. If a Proc, evaluate it in instance context
2. If a Symbol/String, call it as a method
3. Otherwise, call the method with the attribute name

## Testing Approach

Tests verify:
- Basic attribute setting and retrieval
- Conditional rendering with `:if` and `:unless`
- Proc evaluation in correct context
- Proper key transformation (dasherizing)
- Empty value filtering
- Style string formatting

## Common Pitfalls

1. Remember that `has_dom_class` doesn't take a name parameter (unlike other methods)
2. Style values need proper formatting (e.g., "12px" not just 12)
3. All keys are dasherized, so `font_size` becomes `font-size`
4. Empty hashes and arrays are filtered out from the final result

## Release Process

1. Update version in `lib/has_dom_attrs/version.rb`
2. Update CHANGELOG.md with changes
3. Run tests: `bundle exec rake test`
4. Commit changes
5. Run: `bundle exec rake release`

This will create a git tag, push to GitHub, and publish to RubyGems.
