# frozen_string_literal: true

module Feet
  class Namespace
    def self.to_snake_case(string)
      string.gsub(/::/, '/') # to remove the subdirectory feature
            .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z][a-z])/, '\1_\2')
            .tr('-', '_')
            .downcase
    end
  end
end
