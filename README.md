# MrSmime

Secure/Multipurpose Internet Mail Extensions (S/MIME) support for ActionMailer, inspired by a blog post from Andrew
White (https://unboxed.co/blog/sending-smime-encrypted-emails-with-action-mailer/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mr_smime'
```

And then execute:

    $ bundle

## Usage

Setup a certificate-path in your applicaion.rb:

```ruby
module MyApp
  class Application < Rails::Application

    ...

    MrSmime.configure do |config|
      config.certificate_path = Rails.root.join('config', 'certificates')
    end

    ...
  end
end
```

Add certificates for each of your senders (and recipients if you want encryption). We expect a .key and .pem file where
@ has been replaced by . (e.g. john@example.com results in john.example.com.key and john.example.com.pem)

That's it!

## Configuration-options

| Option           | Default value | Description                                          |
|------------------|---------------|------------------------------------------------------|
| certificate_path |               | Pathname to location of certificate-files            |
| enabled          | true          | Boolean to have Mr Smime actually perform it's magic |

## TODO

* Make it easy to save certificates from incoming e-mails (so we can sent encrypted mails back to them)
* Add options to use keys with passphrases
* Add options to enable on a per something base

## Changelog

### 0.1.0 (September 16, 2016)

* Initial release

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Creating self signed certificates

Create a CA certificate first:

```
$ openssl genrsa -out ca.key 4096
$ openssl req -new -x509 -days 365 -key ca.key -out ca.crt
```

Then create a certificate for each of your mail addresses (i'm certain there is a better way to do this):

```
$ openssl genrsa -out jane.example.com.key 4096
$ openssl req -new -key jane.example.com.key -out jane.example.com.csr
$ openssl x509 -req -days 365 -in jane.example.com.csr -CA ca.crt -CAkey ca.key -set_serial 1 -out jane.example.com.crt -setalias "Self Signed SMIME" -addtrust emailProtection -addreject clientAuth -addreject serverAuth -trustout
$ openssl pkcs12 -export -in jane.example.com.crt -inkey jane.example.com.key -out jane.example.com.p12
$ openssl pkcs12 -in jane.example.com.p12 -clcerts -nokeys -out jane.example.com.pem
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bluerail/mr_smime.
