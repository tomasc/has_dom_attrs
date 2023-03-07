# frozen_string_literal: true

require_relative "has_dom_attrs/version"

require "active_support/core_ext/hash/keys"
require "active_support/core_ext/string/inflections"

module HasDomAttrs
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

            super().tap do |classes|
              classes << case value
                         when Proc then instance_exec(&value)
                         when Symbol then send(value)
                         else value
              end
            end
          end
        end
      )
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

            super().tap do |data|
              data[name] = case value
                           when Proc then instance_exec(&value)
                           when Symbol, String then send(value)
                           else send(name)
              end
            end
          end
        end
      )
    end
  end

  def dom_attrs
    {
      aria: dom_aria,
      class: dom_classes,
      data: dom_data,
      style: dom_style
    }.reject { |_, v| v.nil? || v.empty? }
      .deep_stringify_keys
      .deep_transform_keys(&:dasherize)
  end

  def dom_classes
    []
  end

  def dom_aria
    {}
  end

  def dom_data
    {}
  end

  def dom_style
    nil
  end
end
