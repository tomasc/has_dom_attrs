# frozen_string_literal: true

require_relative "has_dom_attrs/version"

require "active_support/core_ext/hash/keys"
require "active_support/core_ext/string/inflections"

module HasDomAttrs
  EMPTY_ARRAY = [].freeze
  EMPTY_HASH = {}.freeze

  class << self
    def included(base)
      base.extend ClassMethods
    end
  end

  module ClassMethods
    def has_dom_attr(name, value = nil, **options)
      prepend___has_dom___method(:dom_attrs, name, value, **options)
    end

    def has_dom_aria(name, value = nil, **options)
      prepend___has_dom___method(:dom_aria, name, value, **options)
    end

    def has_dom_data(name, value = nil, **options)
      prepend___has_dom___method(:dom_data, name, value, **options)
    end

    def has_dom_class(value, **options)
      prepend(
        Module.new do
          define_method :dom_classes do
            cond = options[:if] || options[:unless]
            cond_value = case cond
                         when Proc then instance_exec(&cond)
                         when Symbol, String then send(cond)
            end

            if cond && options.key?(:if)
              return super() unless cond_value
            end

            if cond && options.key?(:unless)
              return super() if cond_value
            end

            resolved = case value
                       when Proc then instance_exec(&value)
                       when Symbol then send(value)
                       else value
            end

            super() + [resolved]
          end
        end
      )
    end

    def has_dom_style(name, value = nil, **options)
      prepend___has_dom___method(:dom_style, name, value, **options)
    end

    private
      def prepend___has_dom___method(method_name, name, value = nil, **options)
        prepend(
          Module.new do
            define_method method_name do
              cond = options[:if] || options[:unless]
              cond_value = case cond
                           when Proc then instance_exec(&cond)
                           when Symbol, String then send(cond)
              end

              if cond && options.key?(:if)
                return super() unless cond_value
              end

              if cond && options.key?(:unless)
                return super() if cond_value
              end

              resolved = case value
                         when Proc then instance_exec(&value)
                         when Symbol, String then send(value)
                         else send(name)
              end

              super().merge(name => resolved)
            end
          end
        )
      end
  end

  def dom_attrs
    result = {}
    aria = dom_aria
    result["aria"] = aria.transform_keys { |k| k.to_s.dasherize } unless aria.empty?
    classes = dom_classes
    result["class"] = classes unless classes.empty?
    data = dom_data
    result["data"] = data.transform_keys { |k| k.to_s.dasherize } unless data.empty?
    style = dom_style.to_s
    result["style"] = style unless style.empty?
    result
  end

  def dom_classes
    EMPTY_ARRAY
  end

  def dom_aria
    EMPTY_HASH
  end

  def dom_data
    EMPTY_HASH
  end

  def dom_style
    EMPTY_STYLE
  end

  class DomStyle < SimpleDelegator
    def merge(other)
      DomStyle.new(__getobj__.merge(other))
    end

    def to_s
      __getobj__.reject { |_, value| value.nil? }
                .map { |key, value| "#{key.to_s.dasherize}: #{value};" }
                .join(" ")
    end
  end

  EMPTY_STYLE = DomStyle.new(EMPTY_HASH).freeze
end
