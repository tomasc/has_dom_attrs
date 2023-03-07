# frozen_string_literal: true

require "test_helper"
require "modulor/component"

module Modulor
  class Component
    class HasDomAttrsTest < ActiveSupport::TestCase
      class ComponentClass < Modulor::Component
        option :attr_value, type: Types::String
        option :aria_value, type: Types::String
        option :data_value, type: Types::String

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

      let(:component) { ComponentClass.new(attr_value: Faker::Name.name, aria_value: Faker::Name.name, data_value: Faker::Name.name) }

      describe "has_dom_attr" do
        it { _(component.send(:dom_attrs)[:attr_value]).must_equal component.attr_value }
        it { _(component.send(:dom_attrs)[:attr_value_spec]).must_equal component.attr_value[0..1] }
        it { _(component.send(:dom_attrs)).must_be :key?, :attr_value_if }
        it { _(component.send(:dom_attrs)).wont_be :key?, :attr_value_unless }
      end

      describe "has_dom_aria" do
        it { _(component.send(:dom_aria)[:aria_value]).must_equal component.aria_value }
        it { _(component.send(:dom_aria)[:aria_value_spec]).must_equal component.aria_value[0..1] }
        it { _(component.send(:dom_aria)).must_be :key?, :aria_value_if }
        it { _(component.send(:dom_aria)).wont_be :key?, :aria_value_unless }
      end

      describe "has_dom_data" do
        it { _(component.send(:dom_data)[:data_value]).must_equal component.data_value }
        it { _(component.send(:dom_data)[:data_value_spec]).must_equal component.data_value[0..1] }
        it { _(component.send(:dom_data)).must_be :key?, :data_value_if }
        it { _(component.send(:dom_data)).wont_be :key?, :data_value_unless }
      end

      describe "has_dom_class" do
        it { _(component.send(:dom_classes)).must_include "foo" }
        it { _(component.send(:dom_classes)).must_include "class_name" }
      end
    end
  end
end
