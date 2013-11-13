# Webio

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'webio'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install webio

## Usage

```hello_webio.rb
webio = WebIO.new('0.0.0.0:9999')
while name=webio.gets
  webio.puts "Hello, #{name.chomp}!"
end
```

and run this script.

```
$ ruby hello_webio.rb
```

Then, you access http://localhost:9999/World and you will see 'Hello, World!'



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
