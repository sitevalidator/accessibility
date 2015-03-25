require 'httparty'
require 'json'

module Accessibility

  ####
  # An Accessibility::Checker is initialized by passing it the URL of the
  # web page to check.
  #
  # It is in charge of making the request to the access-lint-server, which
  # will perform the accessibility audit using the AccessLint gem and return
  # the results as JSON.
  #
  # It delegates the results parsing to an Accessibility::Audit, which in
  # turn will consult the raw JSON from this checker to generate the collections
  # of audit rules.
  #
  # Example:
  #
  #   a11y = Accessibility::Checker.new('http://validationhell.com')
  #
  # You can (and should) specify the URL where your access-lint-server
  # instance is to be found, as the default value is not a production-ready server,
  # which might be under heavy load:
  #
  #   a11y = Accessibility::Checker.new( 'http://validationhell.com',
  #                                      checker_uri: 'http://mychecker.com' )
  #
  # For brevity, you can use the convenience shortcut on the top-level module:
  #
  #   a11y = Accessibility.check('http://validationhell.com')
  #
  class Checker
    attr_reader :url, :checker_uri

    def initialize(url, options = {})
      options = defaults.merge(options)

      @url         = url
      @checker_uri = options[:checker_uri]

      @audit       = Accessibility::Audit.new(self)
    end

    # Returns the parsed JSON from the response of the access-lint-server
    def raw
      @raw ||= JSON.parse HTTParty.get("#{checker_uri}/check?url=#{url}").body
    end

    extend Forwardable
    delegate [:rules, :errors, :warnings] => :@audit

    private

    def defaults
      { checker_uri: 'https://access-lint-server-demo.herokuapp.com' }
    end
  end
end
