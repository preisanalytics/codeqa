# Codeqa

With codeqa you can check your code to comply to certain coding rules (utf8 only chars, indenting) or to avoid typical errors or
enforce deprecations. You might even put it into a pre commit hook.

## Installation

Add this line to your application's Gemfile:

    gem 'codeqa'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install codeqa

## Usage

codeqa filename

## Todo

* load a config to set checkers, and global setting (silence)
* rails3 erb/html parser
* load config from filesystem (global down, /etc/codeqa/config)
* config to skip codeqa on special files
* rake task to check all checked in files of a repo

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
