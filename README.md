# Accessibility [![travis build status](https://secure.travis-ci.org/sitevalidator/accessibility.png?branch=master)](http://travis-ci.org/sitevalidator/accessibility) [![Code Climate](https://codeclimate.com/github/sitevalidator/accessibility/badges/gpa.svg)](https://codeclimate.com/github/sitevalidator/accessibility) [![Dependency Status](https://gemnasium.com/sitevalidator/accessibility.png)](https://gemnasium.com/sitevalidator/accessibility)

Accessibility is a Ruby gem that lets you check for accessibility issues on web pages.

It's a wrapper around the great [AccessLint](https://github.com/accesslint/access_lint) gem, which in turn is a wrapper around the awesome [Accessibility Developer Tools](https://github.com/GoogleChrome/accessibility-developer-tools).

## Why so many wrappers?

The Accessibility Developer Tools, ADT for short, is a JavaScript library developed by the [Google Chrome team](https://github.com/GoogleChrome), which can be used as a [Google Chrome extension](https://chrome.google.com/webstore/detail/accessibility-developer-t/fpkknkljclfencbdbgkenhalefipecmb), or from the command line via [PhantomJS](http://phantomjs.org/).

What the AccessLint gem does is wrap this JS library in a Ruby gem, so that you can easily run it on your Ruby projects in a convenient way.

I found that using the AccessLint gem directly on my Ruby projects had some drawbacks:

1. It introduced a dependency on PhantomJS, and this is a quite heavy dependency. PhantomJS can be hard to compile and it takes a lot of memory.
2. To get the results, AccessLint executes phantom JS via a [shell command](https://github.com/accesslint/access_lint/blob/master/lib/access_lint/runner.rb#L11), which is something I don't feel very comfortable with.
3. The AccessLint returns a raw JSON with the results, and I'd prefer to add a more friendly API over it.

## Enter access-lint-server

I prefer to move this heavy dependency out of my projects, so I released the [access-lint-server](https://github.com/sitevalidator/access-lint-server), which is a lightweight server based on Sinatra, that you can easily set up (for example in Heroku), to have a microservice in charge of doing the A11Y checks with the AccessLint gem. That's where the dependency on PhantomJS now resides, and not on your main project.

Also, it allows for easy scaling. ADT can take several seconds (or tens of seconds) to respond, so a suggested approach is having several access-lint-server instances and a load balancer in front of them.

To make it easier to process the raw JSON response, Accessibility is a Ruby client that uses an access-lint-server instance and gives you the results in a more friendly way.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'accessibility'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install accessibility

## Usage

To check accessibility on a web page, just pass Accessibility the URL to check, like this:

```ruby
a11y = Accessibility.check('http://validationhell.com')
```

Now you can get the errors and warnings like this:

```ruby
a11y.errors
a11y.warnings
```

Each of these methods will return an array of audit rules that your web page failed to comply with. Each rule has its details, let's see for example:

```ruby
a11y = Accessibility.check('http://validationhell.com')

warning = a11y.warnings.last
warning.title         # "Text elements should have a reasonable contrast ratio"
warning.element_names # ["<a href=\"/pages/why\">Why nobody validates</a>", "<a href=\"/pages/circle/1\">Limbo</a>"]
```

## Audit Rules

Currently, AccessLint has a [list of 17 audit rules](https://github.com/accesslint/access_lint#rules). Each of these will be checked on your documents, and
you can inspect them like this:

```ruby
a11y = Accessibility.check('http://validationhell.com')

a11y.rules.all            # all the checked rules
a11y.rules.not_applicable # rules that were not applicable to the checked page
a11y.rules.passed         # rules that passed on the checked document
a11y.rules.failed         # rules that failed on the checked document
a11y.errors               # rules that failed with a severity of "Severe"
a11y.warnings             # rules that failed with a severity of "Warning"
```

Each rule has the following attributes:

attribute     | description
--------------|-----------------------------------------------------------------
status        | "NA" (not applicable), "PASS", or "FAIL"
severity      | "Severe" or "Warning"
title         | a description of the rule
element_names | an array of strings, each of them being a snippet of the document where the issue was found

## Using your own access-lint-server instance

By default, Accessibility will use a demo instance of access-lint-server, which is intended only for demo purposes and not ready for production.

You're encouraged to [install your own instance](https://github.com/sitevalidator/access-lint-server) and use it like this:

```ruby
a11y = Accessibility::Checker.new( 'http://validationhell.com',
                                   checker_uri: 'http://mychecker.com' )
```

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `bundle console` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it ( https://github.com/sitevalidator/accessibility/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
