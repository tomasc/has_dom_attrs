require "test_helper"
require "ostruct"

class Component
  include HasDomAttrs

  attr_accessor :attr_value
  attr_accessor :aria_value
  attr_accessor :data_value

  def initialize(attr_value: "", aria_value: "", data_value: "")
    @attr_value = attr_value
    @aria_value = aria_value
    @data_value = data_value
  end

  has_dom_attr :attr_value
  has_dom_attr :attr_value_spec, -> { attr_value[0..1] }
  has_dom_attr :attr_value_if, -> { attr_value[2..4] }, if: :if?
  has_dom_attr :attr_value_unless, -> { attr_value[2..4] }, unless: :unless?

  has_dom_aria :aria_value
  has_dom_aria :aria_value_spec, -> { aria_value[0..1] }
  has_dom_aria :aria_value_if, -> { aria_value[2..4] }, if: :if?
  has_dom_aria :aria_value_unless, -> { aria_value[2..4] }, unless: :unless?

  has_dom_data :data_value
  has_dom_data :data_value_spec, -> { data_value[0..1] }
  has_dom_data :data_value_if, -> { data_value[2..4] }, if: :if?
  has_dom_data :data_value_unless, -> { data_value[2..4] }, unless: :unless?

  has_dom_class "foo"
  has_dom_class :class_name

  def if?
    true
  end

  def unless?
    true
  end

  def styles
    OpenStruct.new(class_name: ".class_name", other_class_name: ".other_class_name")
  end
end

class HasDomAttrsTest < Minitest::Test
  def test_has_dom_attr
    component = Component.new(attr_value: "Jens Jensen")
    dom_attrs = component.send(:dom_attrs)

    assert_equal dom_attrs[:attr_value], "Jens Jensen"
    assert_equal dom_attrs[:attr_value_spec], "Je"
    assert dom_attrs.key?(:attr_value_if)
    refute dom_attrs.key?(:attr_value_unless)
  end

  def test_has_dom_aria
    component = Component.new(aria_value: "Jens Jensen")
    dom_aria = component.send(:dom_aria)

    assert_equal dom_aria[:aria_value], "Jens Jensen"
    assert_equal dom_aria[:aria_value_spec], "Je"
    assert dom_aria.key?(:aria_value_if)
    refute dom_aria.key?(:aria_value_unless)
  end

  def test_has_dom_data
    component = Component.new(data_value: "Jens Jensen")
    dom_data = component.send(:dom_data)

    assert_equal dom_data[:data_value], "Jens Jensen"
    assert_equal dom_data[:data_value_spec], "Je"
    assert dom_data.key?(:data_value_if)
    refute dom_data.key?(:data_value_unless)
  end

  def test_has_dom_class
    component = Component.new
    dom_classes = component.send(:dom_classes)

    assert_includes dom_classes, "foo"
    assert_includes dom_classes, "class_name"
  end
end
