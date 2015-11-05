# Oauth2HmacHeader

[![Build Status](https://travis-ci.org/mustafaturan/oauth2_hmac_header.png)](https://travis-ci.org/mustafaturan/oauth2_hmac_header) [![Code Climate](https://codeclimate.com/github/mustafaturan/oauth2_hmac_header.png)](https://codeclimate.com/github/mustafaturan/oauth2_hmac_header)

Simple generator, parser and validator for Oauth v2 HTTP message authentication code(MAC) header. It simply generates, parse and verify signatures for Oauth v2 HTTP MAC authentication for 'SHA1' and 'SHA256' algorithms. Please visit https://tools.ietf.org/html/draft-ietf-oauth-v2-http-mac-01 for spec specifications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'oauth2_hmac_header'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install oauth2_hmac_header

## Usage

### Generating from request vars
```ruby
    
    @client_id = 'client1'
    @algorithm = 'hmac-sha-256' # 'hmac-sha-1' or 'hmac-sha-256'
    @key = 'demo_key' # key for client1
    @method = 'post' # get, post, put, head, patch, etc...
    @uri = '/request?b5=%3D%253D&a3=a&c%40=&a2=r%20b&c2&a3=2+q' # path for req
    @host = 'example.com' # hostname for the request
    @port = 443 # port number for the request
    @ext = 'a,b,c' # optional str, can be nil
    
    # generate header
    @header = Oauth2HmacHeader::AuthorizationHeader.generate_with_new_signature(
      @client_id, @algorithm, @key, @method, @uri, @host, @port, @ext
    )
    
    # returns header
    # "MAC id=\"client1\", ts=\"1438532302\", nonce=\"1438532302:12c8e929\", ext=\"a,b,c\", mac=\"F4nIHqhQZp1o2I61Zy9bSZFYfohf9gmdG0XnOIMAHV4=\""
```

### Generating with early signed signatures
```ruby
    
    @client_id = 'client1'
    @algorithm = 'hmac-sha-256' # 'hmac-sha-1' or 'hmac-sha-256'
    @key = 'demo_key' # key for client1
    @method = 'post' # get, post, put, head, patch, etc...
    @uri = '/request?b5=%3D%253D&a3=a&c%40=&a2=r%20b&c2&a3=2+q' # path for req
    @host = 'example.com' # hostname for the request
    @port = 443 # port number for the request
    @ext = 'a,b,c' # optional str, can be nil
    
    # generate HMAC signature and vars 
    @ts, @nonce, @ext, @mac  = Oauth2HmacSign::Signature.generate(
      @algorithm, @key, @method, @uri, @host, @port, @ext
    )
    
    # generate header
    @header = Oauth2HmacHeader::AuthorizationHeader.generate(
      @client_id, @ts, @nonce, @ext, @mac
    )
    
    # returns header
    # "MAC id=\"client1\", ts=\"1438530720\", nonce=\"1438530720:ab4412bd\", ext=\"a,b,c\", mac=\"Sav0I-p1rAU29TlISoznME5xeOzJIPZEvG26ni_APNE=\""
```

### Parsing
```ruby
    
    @header = "MAC id=\"client1\", ts=\"1438530720\", nonce=\"1438530720:ab4412bd\", ext=\"a,b,c\", mac=\"Sav0I-p1rAU29TlISoznME5xeOzJIPZEvG26ni_APNE=\""
    @client_id, @ts, @nonce, @ext, @mac = Oauth2HmacHeader::AuthorizationHeader.parse(@header)

    # returns authorization vars
    # client_id
    # ts
    # nonce
    # mac
```

### Verify
```ruby
    
    # Assuming that we know the variables below from the incoming HTTP request
    @method = 'post' # get, post, put, head, patch, etc...
    @uri = '/request?b5=%3D%253D&a3=a&c%40=&a2=r%20b&c2&a3=2+q' # path for req
    @host = 'example.com' # hostname for the request
    @port = 443 # port number for the request
    
    # lets parse auth vars from header
    @header = "MAC id=\"client1\", ts=\"1438530720\", nonce=\"1438530720:ab4412bd\", ext=\"a,b,c\", mac=\"Sav0I-p1rAU29TlISoznME5xeOzJIPZEvG26ni_APNE=\""
    @client_id, @ts, @nonce, @ext, @mac = Oauth2HmacHeader::AuthorizationHeader.parse(@header)
    
    # now we know 'client1' is the requester from parsed header and so we have the key and algorithm for 'client1' which is 'demo_key' and 'hmac-sha-256'
    @key = 'demo_key'
    @algorithm = 'hmac-sha-256'
    
    # let check if it is valid?
    Oauth2HmacHeader::AuthorizationHeader.is_valid?(
      @mac,
      @algorithm,
      @key,
      @ts,
      @nonce,
      @method,
      @uri,
      @host,
      @port,
      @ext
    )
    
    # if request is valid for client1 then expect to return true
```

## Contributing

1. Fork it ( https://github.com/mustafaturan/oauth2_hmac_header/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
