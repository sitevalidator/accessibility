require "forwardable"
require "accessibility/version"
require "accessibility/checker"
require "accessibility/audit"
require "accessibility/rule"

module Accessibility
  def self.check(url, options = {})
    Accessibility::Checker.new(url, options)
  end
end
