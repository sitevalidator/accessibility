require 'spec_helper'
require 'json'

describe Accessibility::Rule do
  it "sets attributes from data" do
    rule = Accessibility::Rule.new(rules[0])

    expect(rule.element_names).to eq rules[0]['element_names']
    expect(rule.severity).to      eq rules[0]['severity']
    expect(rule.status).to        eq rules[0]['status']
    expect(rule.title).to         eq rules[0]['title']
  end

  private

  def rules
    JSON.parse(fixture_file('validationhell.json'))['FAIL']
  end
end
