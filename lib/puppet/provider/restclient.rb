# Helper functions

require 'json'
require 'net/http'
require 'openssl'
require 'uri'

class Puppet::Provider::RestClient
  def initialize(apiurl, apiuser, apipass)
    @uri = URI.parse(apiurl)
    @apiuser = apiuser
    @apipass = apipass
    @property_hash = {}
  end

  def request(context, endpoint, method=Net::HTTP::Get, data=nil)
    request = method.new("#{@uri.path}/#{endpoint}/", 'Content-Type' => 'application/json')
    request.basic_auth @apiuser, @apipass
    request.body = JSON.generate(data) if data
    response = connection.request(request)
    if response.body == "null"
      res = nil
    else
      res = JSON.parse(response.body)
    end
    res
  end

  def connection
    unless @connection
      @connection = Net::HTTP::new(@uri.host, @uri.port)
      @connection.verify_mode = OpenSSL::SSL::Verify_NONE
    end
    @connection
  end

  def get_pulp_objects(context)
    begin
      response = request(context, endpoint)
      context.debug("Number of objects found: '#{response['count']}'")
      context.debug("Found objects: '#{JSON.pretty_generate(response['results'])}'")
      return [] if response['count'] == '0'
      objects = response['results']
    rescue StandardError => e
      context.err("Error while getting list of objects: '#{e}'")
      return []
    end
    objects
  end

  def get_pulp_href(name, context)
    @property_hash.each do |property|
      if property[:name] == name
        context.debug("Found pulp_href of #{name}: #{property[:pulp_href]}")
        return property[:pulp_href]
      end
    end
    context.err("Pulp_href not found for #{name}")
    return nil
  end
end
