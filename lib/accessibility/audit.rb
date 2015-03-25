module Accessibility

  ####
  # An Accessibility::Audit is in charge of parsing the rules found on
  # the raw response from the access-lint-server, available on the Checker,
  # and filtering them by different criteria.
  #
  class Audit
    def initialize(checker)
      @checker = checker
    end

    extend Forwardable
    delegate :raw => :@checker

    def rules
      self
    end

    # Returns all the rules
    def all
      @rules ||= raw.values.flatten.map { |rule| Accessibility::Rule.new(rule) }
    end

    # Returns the rules that were not applicable to the checked document
    def not_applicable
      @not_applicable ||= all.select { |rule| rule.status == "NA" }
    end

    # Returns the rules that passed on the checked document
    def passed
      @passed ||= all.select { |rule| rule.status == "PASS" }
    end

    # Returns the rules that failed on the checked document
    def failed
      @failed ||= all.select { |rule| rule.status == "FAIL" }
    end

    # Returns the rules that failed with a severity of "Severe"
    def errors
      @errors ||= failed.select { |rule| rule.severity == "Severe" }
    end

    # Returns the rules that failed with a severity of "Warning"
    def warnings
      @warnings ||= failed.select { |rule| rule.severity == "Warning" }
    end
  end
end
