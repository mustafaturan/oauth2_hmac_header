require 'forwardable'
require 'oauth2_hmac_sign'

module Oauth2HmacHeader
  # The "Authorization" Request Header
  class AuthorizationHeader
    extend SingleForwardable
    def_delegator Oauth2HmacSign::Signature, :is_valid?

    attr_reader :id, :ts, :nonce, :ext, :mac

    class << self

      # Generates oauth2 hmac authorization header
      #
      # == Parameters:
      # id::
      #   Client id for mac auth
      # ts::
      #   The timestamp value calculated for the request.
      # nonce::
      #   The nonce value generated for the request.
      # ext:: 
      #   The value of the "ext" "Authorization" request header field attribute
      #   if one was included in the request, otherwise, an empty string.
      # mac::
      #   The signature
      #
      # == Returns:
      #   Returns the generated header as string 
      #
      def generate(id, ts, nonce, ext, mac)
        header = "MAC "
        header << "id=\"#{id}\", "
        header << "ts=\"#{ts}\", "
        header << "nonce=\"#{nonce}\", "
        header << "ext=\"#{ext}\", " if (!ext.nil? && !ext.empty?)
        header << "mac=\"#{mac}\""
        header
      end

      # Generates oauth2 hmac authorization header
      #
      # == Parameters:
      # id::
      #   Client id for mac auth
      # algorithm::
      #   Name of the algorithm valid vars are hmac-sha256, hmac-sha1
      # key::
      #   Key for hmac algorithm
      # method::
      #   The HTTP request method in upper case.  For example: "HEAD", "GET", "POST", etc.
      # uri::
      #   The HTTP request-URI as defined by https://tools.ietf.org/html/rfc2616#section-5.1.2
      # host::
      #   The hostname included in the HTTP request using the "Host" request header field in lower case.
      # port::
      #   The port as included in the HTTP request using the "Host" request
      #   header field.  If the header field does not include a port, the
      #   default value for the scheme MUST be used (e.g. 80 for HTTP and
      #   443 for HTTPS).
      # ext:: 
      #   The value of the "ext" "Authorization" request header field
      #   attribute if one was included in the request, otherwise, an empty
      #   string.
      #
      # == Returns:
      #   Returns the generated header as string 
      #
      def generate_with_new_signature(id, algorithm, key, method, uri, host, port, ext = '')
        ts, nonce, ext, mac  = Oauth2HmacSign::Signature.generate(
          algorithm, key, method, uri, host, port, ext
        )
        generate(id, ts, nonce, ext, mac)
      end

      # Parses oauth2 hmac header
      #
      # == Parameters:
      # header::
      #   Client id for mac auth
      #
      # == Returns:
      #   Returns the generated header as string 
      # id::
      #   Client id for mac auth
      # ts::
      #   The timestamp value calculated for the request.
      # nonce::
      #   The nonce value generated for the request.
      # ext:: 
      #   The value of the "ext" "Authorization" request header field attribute
      #   if one was included in the request, otherwise, an empty string.
      # mac::
      #   The signature
      #
      def parse(header)
        pattern = Regexp.new "(id|ts|nonce|ext|mac)=(\"[^\"]+\")"
        results = Hash[header.scan pattern]
        validate_presence_of_keys_and_values(results, ['id', 'ts', 'nonce', 'mac'])
        results = clean_quotes(results)
        return results['id'], results['ts'], results['nonce'], results['ext'], results['mac']
      end

      private

      # nodoc
      def clean_quotes(items)
        items.each {|item| item[1].gsub!('"', '') }
        items
      end

      # nodoc
      # Verify required keys existence
      def validate_presence_of_keys_and_values(hash, keys)
        keys.each do |key|
          raise(KeyError, "#{key} is a MUST field for Oauth V2 HMAC Authorization header and can not be blank.") unless hash.has_key?(key)
        end
      end
    end
  end
end