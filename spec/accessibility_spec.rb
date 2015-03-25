require 'spec_helper'

describe Accessibility do
  before(:each) do
    stub_request(:get, "https://access-lint-server-demo.herokuapp.com/check?url=http://validationhell.com").
      to_return(:status => 200, :body => fixture_file('validationhell.json'))
  end

  describe 'initialization' do
    it 'sets the URL of the document to check' do
      checker = Accessibility.check('http://validationhell.com')

      expect(checker.url).to eq 'http://validationhell.com'
    end

    it 'has a default checker URI' do
      checker = Accessibility.check('http://validationhell.com')

      expect(checker.checker_uri).to eq 'https://access-lint-server-demo.herokuapp.com'
    end

    it 'checker URI can be set' do
      checker = Accessibility.check('http://validationhell.com',
                              checker_uri: 'http://checker.example.com/')

      expect(checker.checker_uri).to eq 'http://checker.example.com/'
    end
  end

  describe 'checking markup' do
    let(:checker) { Accessibility.check('http://validationhell.com') }

    it 'returns the raw JSON response' do
      expect(checker.raw).to eq JSON.parse(fixture_file('validationhell.json'))
    end

    it 'returns the list of all rules' do
      expect(checker.rules.all.length).to eq 17
      expect(checker.rules.all.first.title).to eq "aria-owns should not be used if ownership is implicit in the DOM"
    end

    it 'filters not applicable rules' do
      expect(checker.rules.not_applicable.length).to eq 10
      expect(checker.rules.not_applicable.first.title).to eq "aria-owns should not be used if ownership is implicit in the DOM"
    end

    it 'filters passed rules' do
      expect(checker.rules.passed.length).to eq 3
      expect(checker.rules.passed.first.title).to eq "The web page should have the content's human language indicated in the markup"
    end

    it 'filters failed rules' do
      expect(checker.rules.failed.length).to eq 4
      expect(checker.rules.failed.first.title).to eq "Controls and media elements should have labels"
    end

    it 'filters errors' do
      expect(checker.errors.length).to eq 1
      expect(checker.errors.first.title).to eq "Controls and media elements should have labels"
    end

    it 'filters warnings' do
      expect(checker.warnings.length).to eq 3
      expect(checker.warnings.first.title).to eq "Images should have an alt attribute"
    end
  end
end
