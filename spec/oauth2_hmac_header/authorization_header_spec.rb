require 'spec_helper'

describe Oauth2HmacHeader::AuthorizationHeader do
  before(:all) do
    @client_id = 'client1'
    @algorithm = 'hmac-sha-256'
    @key = 'demo_key'
    @method = 'post'
    @uri = '/request?b5=%3D%253D&a3=a&c%40=&a2=r%20b&c2&a3=2+q'
    @host = 'example.com'
    @port = 443
    @ext = 'a,b,c'
    @ts, @nonce, @ext, @mac  = Oauth2HmacSign::Signature.generate(
      @algorithm, @key, @method, @uri, @host, @port, @ext
    )
  end

  describe '.generate' do
    it 'generates oauth2 hmac authorization header using early generated ts, nonce, ext and mac vars' do
      @header = Oauth2HmacHeader::AuthorizationHeader.generate(
        @client_id, @ts, @nonce, @ext, @mac
      )
      expect(@header).to eq(
        "MAC id=\"#{@client_id}\", ts=\"#{@ts}\", nonce=\"#{@nonce}\", ext=\"#{@ext}\", mac=\"#{@mac}\""
      )
    end
  end

  describe '.generate_with_new_signature' do
    it 'generate complete request header string using request vars' do
      header_new = Oauth2HmacHeader::AuthorizationHeader.generate_with_new_signature(
        @client_id, @algorithm, @key, @method, @uri, @host, @port, @ext
      )
      expect(header_new).to include('MAC ')
      expect(header_new).to include('mac=')
      expect(header_new).to include('id=')
      expect(header_new).to include('ts=')
      expect(header_new).to include('nonce=')
      expect(header_new).to include('ext=')
    end
  end

  describe '.parse' do
    it 'parses oauth2 hmac header and extract vars' do
      @header = Oauth2HmacHeader::AuthorizationHeader.generate(
        @client_id, @ts, @nonce, @ext, @mac
      )
      id_parsed, ts_parsed, nonce_parsed, ext_parsed, mac_parsed = Oauth2HmacHeader::AuthorizationHeader.parse(@header)
      expect(id_parsed).to eq(@client_id)
      expect(ts_parsed).to eq(@ts.to_s)
      expect(nonce_parsed).to eq(@nonce)
      expect(ext_parsed).to eq(@ext)
      expect(mac_parsed).to eq(@mac)
    end

    it 'unparsable headers raises error' do
      @header = Oauth2HmacHeader::AuthorizationHeader.generate(
        @client_id, @ts, @nonce, @ext, @mac
      )
      header1 = @header.gsub(/(mac=\"[^"]+\")/, '')
      header2 = @header.gsub(/(mac=\"[^"]+)/, 'mac="')
      expect {Oauth2HmacHeader::AuthorizationHeader.parse(header1)}.to raise_error(KeyError)
      expect {Oauth2HmacHeader::AuthorizationHeader.parse(header2)}.to raise_error(KeyError)
    end
  end
end