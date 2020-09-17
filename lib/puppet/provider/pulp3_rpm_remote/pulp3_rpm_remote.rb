# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'

require 'rubygems'
require 'rest-client'
require 'json'

# Implementation for the pulp3_rpm_remote type using the Resource API.
class Puppet::Provider::Pulp3RpmRemote::Pulp3RpmRemote < Puppet::ResourceApi::SimpleProvider
  def initialize
    @apiuser = 'admin'
    @apipass = 'adminpassword'
    @apihost = 'pulp.xxs.vagrant'
    @apiport = '24817'
    @uri = "http://#{@apiuser}:#{@apipass}@#{@apihost}:#{@apiport}"
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

  def build_hash(object)
    hash = {}
    hash[:ensure] = 'present'
    hash[:name] = object['name']
    hash[:url] = object['url']
    hash[:pulp_href] = object['pulp_href']
    hash
  end

  def create(context, name, should)
    context.debug("Creating '#{name}' with #{should.inspect}")
    data = { 'name'      => should[:name],
             'url'       => should[:url], 
    }
    begin
      context.debug("The uri is #{@uri}#{@endpoint}")
      response = RestClient.post "#{@uri}#{@endpoint}",
        data.to_json,
        { content_type: :json, accept: :json }
      context.debug("The REST API Post response is #{JSON.parse(response)}")
    rescue StandardError => e
      context.err("The response to the request was '#{JSON.parse(response)}'")
      context.err("Creating remote '#{name}' failed with: #{e}")
    end
  end

  def update(context, name, should)
    context.debug("Updating '#{name}' with #{should.inspect}")
    pulp_href = get_pulp_href(name, context)
    data = { 'name' => should[:name],
             'url'  => should[:url], }
    begin
      res = RestClient.put "#{@uri}#{pulp_href}",
        data.to_json,
        { content_type: :json, accept: :json }
      response = JSON.parse(res)
      context.debug("Object #{name} motified with following task: #{response}")
    rescue StandardError => e
      context.err("Updating remote '#{name}' failed with: #{e}")
    end
  end

  def delete(context, name)
    context.debug("Deleting '#{name}'")
    pulp_href = get_pulp_href(name, context)
    begin
      res = RestClient.delete "#{@uri}#{pulp_href}",
        { content_type: :json, accept: :json }
      response = JSON.parse(res)
      context.debug("Object deleted with following task: #{response}")
    rescue StandardError => e
      context.err("Deleting remote '#{name}' failed with: #{e}")
    end
  end

  def get_pulp_objects(context)
    begin
      res = RestClient.get "#{@uri}#{@endpoint}",
        { content_type: :json, accept: :json }
      response = JSON.parse(res)
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
