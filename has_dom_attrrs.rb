# frozen_string_literal: true

module Modulor
  class Component
    module HasDomAttrs
      extend ActiveSupport::Concern

      included do
        delegate  :controller_name,
                  to: :class
      end

      module ClassMethods
        def controller_name
          model_name.to_s.underscore.dasherize.gsub("/", "--")
        end

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
                             when Symbol then styles.send(value)&.delete_prefix(".")
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

      private
        def dom_attrs
          {
            aria: dom_aria,
            class: dom_classes,
            data: dom_data,
            style: dom_style
          }.reject { |_, v| v.blank? }
           .deep_stringify_keys.deep_transform_keys(&:dasherize)
        end

        def dom_classes
          @dom_classes ||= self.class
              .ancestors
              .select { |cls| cls < Modulor::Component }
              .map(&:styles)
              .compact
              .map(&:root)
              .compact
              .reverse
        end

        def dom_aria
          {}
        end

        def dom_data
          {}
        end

        def controller_data
          { controller: controller_name }
        end

        def dom_style
          nil
        end
    end
  end
end
