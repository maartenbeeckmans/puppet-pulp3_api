# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'
require 'rubygems'
require 'rest-client'
require 'json'
require 'uri'

# Implementation for the pulp3_rpm_remote type using the Resource API.
class Puppet::Provider::Pulp3RpmRemote::Pulp3RpmRemote < Puppet::ResourceApi::SimpleProvider
  def initialize
    @apiuser = 'admin'
    @apipass = 'adminpassword'
    @apihost = 'pulp.xxs.vagrant'
    @apiport = '24817'
    @endpoint = '/pulp/api/v3/remotes/rpm/rpm/'
    @property_hash = []
  end

  def get(context)
    if @property_hash.empty?
      parsed_objects = []
      get_pulp_objects(context).each do |object|
        remote = build_hash(object)
        parsed_objects << remote
      end
      context.debug("Retrieved the following resources: #{parsed_objects}")
      @property_hash = parsed_objects
    end
    @property_hash
  end

  def create(context, name, should)
    context.debug("Creating '#{name}' with #{should.inspect}")
    data = { 'name'      => should[:name],
             'url'       => should[:url], 
    }
    begin
      context.debug("The uri is #{@uri}#{@endpoint}")
      response = request(@endpoint, Net::HTTP::Post, data)
      context.debug("The REST API Post response is #{response}")
    rescue StandardError => e
      context.err("The response to the request was '#{response}'")
      context.err("Creating remote '#{name}' failed with: #{e}")
    end
  end

  def update(context, name, should)
    context.debug("Updating '#{name}' with #{should.inspect}")
    pulp_href = get_pulp_href(name, context)
    data = { 'name' => should[:name],
             'url'  => should[:url], }
    begin
      response = request(pulp_href, Net::HTTP::Put, data)
      context.debug("Object #{name} motified with following task: #{response}")
    rescue StandardError => e
      context.err("Updating remote '#{name}' failed with: #{e}")
    end
  end

  def delete(context, name)
    context.debug("Deleting '#{name}'")
    pulp_href = get_pulp_href(name, context)
    begin
      response = request(pulp_href, Net::HTTP::Delete)
      context.debug("Object deleted with following task: #{response}")
    rescue StandardError => e
      context.err("Deleting remote '#{name}' failed with: #{e}")
    end
  end

  # Data parser methods
  def build_hash(object)
    hash = {}
    hash[:ensure] = 'present'
    hash[:name] = object['name']
    hash[:url] = object['url']
    hash[:pulp_href] = object['pulp_href']
    hash
  end

  # Helper methods
  def request(endpoint, method=Net::HTTP::Get, data=nil)
    uri = URI("http://#{@apihost}:#{@apiport}#{endpoint}")
    request = method.new(uri, 'Content-Type' => 'application/json')
    request.basic_auth @apiuser, @apipass
    request.body = JSON.generate(data) if data
    unless @connection
      @connection = Net::HTTP::new(uri.host, uri.port)
      @connection.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    response = @connection.request(request)
    if response.body == "null"
      res = nil
    else
      res = JSON.parse(response.body)
    end
    res
  end

  def get_pulp_objects(context)
    begin
      response = request(@endpoint)
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
