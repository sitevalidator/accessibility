module Accessibility
  class Rule
    attr_reader :element_names, :severity, :status, :title

    ####
    # An Accessibility::Rule represents a single Accessibility Developer Tools
    # audit rule that is checked on the document.
    #
    # A Rule has the following attributes:
    #
    #   * status, which can be "NA" (not applicable), "PASS", or "FAIL"
    #   * severity, which can be "Severe" or "Warning"
    #   * title, which is a description of the rule
    #   * element_names, an array of strings, each of them being a snippet of
    #                    the document where the issue was found
    # 
    def initialize(data)
      @element_names = data['element_names']
      @severity      = data['severity']
      @status        = data['status']
      @title         = data['title']
    end
  end
end
