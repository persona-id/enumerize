# frozen_string_literal: true

module Enumerize
  # Automatic constants definition.
  #
  # Basic usage:
  #
  #     class User
  #       extend Enumerize
  #       enumerize :sex, in: %w(male female), constants: true
  #     end
  #
  #     User::SEX_MALE   # => 'male'
  #     User::SEX_FEMALE # => 'female'
  #
  # Using prefix:
  #
  #     class User
  #       extend Enumerize
  #       enumerize :sex, in: %w(male female), constants: { prefix: 'FOO' }
  #     end
  #
  #     User::FOO_MALE
  #     User::FOO_FEMALE
  #
  # Use <tt>only</tt> and <tt>except</tt> options to specify what values create
  # constants for.
  module Constants
    def enumerize(name, options={})
      super

      if options[:constants]
        Builder.new(enumerized_attributes[name], options[:constants]).build(_enumerize_module)
      end
    end

    class Builder
      def initialize(attr, options)
        @attr    = attr
        @options = options.is_a?(Hash) ? options : {}
      end

      def values
        values = @attr.values

        if @options[:only]
          values &= Array(@options[:only]).map(&:to_s)
        end

        if @options[:except]
          values -= Array(@options[:except]).map(&:to_s)
        end

        values
      end

      def build(klass)
        values.each do |value|
          prefix = @options[:prefix] || @attr.name
          const_name = "#{prefix.upcase}_#{value.tr('-', '_').upcase}"
          unless klass.const_defined?(const_name)
            klass.const_set(const_name, value)
          end
        end
      end
    end
  end
end
