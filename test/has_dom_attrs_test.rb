# frozen_string_literal: true

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
  has_dom_class -> { "component--width_#{width}" }
  has_dom_class -> { "component--open" }, if: :open?
  has_dom_class "if", if: :if?
  has_dom_class "unless", unless: :unless?

  has_dom_style :height
  has_dom_style :font_size, -> { "12px" }
  has_dom_style :color, -> { "red" }, if: :if?
  has_dom_style :background_color, -> { "blue" }, unless: :unless?

  private
    def class_name
      "component--class"
    end

    def width
      :m
    end

    def height
      "100vh"
    end

    def open?
      true
    end

    def if?
      true
    end

    def unless?
      true
    end
end

class HasDomAttrsTest < Minitest::Test
  def test_has_dom_attr
    component = Component.new(attr_value: "Jens Jensen")
    dom_attrs = component.dom_attrs

    assert_equal "Jens Jensen", dom_attrs[:attr_value]
    assert_equal "Je", dom_attrs[:attr_value_spec]
    assert dom_attrs.key?(:attr_value_if)
    assert dom_attrs.key?(:attr_value_unless) == false
  end

  def test_has_dom_aria
    component = Component.new(aria_value: "Jens Jensen")
    dom_aria = component.dom_aria

    assert_equal "Jens Jensen", dom_aria[:aria_value]
    assert_equal "Je", dom_aria[:aria_value_spec]
    assert dom_aria.key?(:aria_value_if)
    assert dom_aria.key?(:aria_value_unless) == false
  end

  def test_has_dom_data
    component = Component.new(data_value: "Jens Jensen")
    dom_data = component.dom_data

    assert_equal "Jens Jensen", dom_data[:data_value]
    assert_equal "Je", dom_data[:data_value_spec]
    assert dom_data.key?(:data_value_if)
    assert dom_data.key?(:data_value_unless) == false
  end

  def test_has_dom_class
    component = Component.new
    dom_classes = component.dom_classes

    assert_includes dom_classes, "foo"
    assert_includes dom_classes, "component--class"
    assert_includes dom_classes, "component--width_m"
    assert_includes dom_classes, "component--open"
    assert_includes dom_classes, "if"
    assert dom_classes.include?("unless") == false
  end

  def test_has_dom_style
    component = Component.new
    dom_style = component.dom_style

    assert_includes dom_style.to_s, "height: 100vh;"
    assert_includes dom_style.to_s, "font-size: 12px;"
    assert_includes dom_style.to_s, "color: red;"
    assert dom_style.to_s.include?("background-color: blue;") == false
  end
end
