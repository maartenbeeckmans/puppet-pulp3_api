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
  end

  def get(context)
    objects = get_pulp_objects(context)
    context.debug("Entered get")
    context.debug("Following objects were retrieved: #{objects}")
    parsed_objects = []
    objects.each do |object|
      remote = parse_object(object)
      parsed_objects << remote
    end
    context.notice("Parsed objects are: #{parsed_objects}")
    parsed_objects
  end

  def parse_object(object)
    hash = {}
    hash[:ensure] = 'present'
    hash[:name] = object['name']
    hash[:url] = object['url']
    hash
  end

  def name?(object)
    !object['name'].nil? && !object['name'].empty?
  end

  def create(context, name, should)
    context.notice("Creating '#{name}' with #{should.inspect}")
    data = { 'name' => should[:name],
             'url'  => should[:url], }
    begin
      context.notice("The uri is #{@uri}#{@endpoint}")
      response = RestClient.post "#{@uri}#{@endpoint}",
        data.to_json,
        { content_type: :json, accept: :json }
      context.notice("The REST API Post response is #{JSON.parse(response)}")
    rescue StandardError => e
      context.err("The response to the request was '#{JSON.parse(response)}'")
      context.err("Creating remote '#{name}' failed with: #{e}")
    end
  end

  def update(context, name, should)
    context.notice("Updating '#{name}' with #{should.inspect}")
    pulp_href = get_pulp_href(name, context)
    data = { 'name' => should[:name],
             'url'  => should[:url], }
    begin
      res = RestClient.put "#{@uri}#{pulp_href}",
        data.to_json,
        { content_type: :json, accept: :json }
      response = JSON.parse(res)
      context.notice("Object #{name} motified with following task: #{response}")
    rescue StandardError => e
      context.err("Updating remote '#{name}' failed with: #{e}")
    end
  end

  def delete(context, name)
    context.notice("Deleting '#{name}'")
    pulp_href = get_pulp_href(name, context)
    begin
      res = RestClient.delete "#{@uri}#{pulp_href}",
        { content_type: :json, accept: :json }
      response = JSON.parse(res)
      context.notice("Object deleted with following task: #{response}")
    rescue StandardError => e
      context.err("Deleting remote '#{name}' failed with: #{e}")
    end
  end

  # Custom fuctions
  def get_pulp_objects(context)
    begin
      res = RestClient.get "#{@uri}#{@endpoint}",
        { content_type: :json, accept: :json }
      response = JSON.parse(res)
      context.notice("Number of objects found: '#{response['count']}'")
      context.notice("Found objects: '#{JSON.pretty_generate(response['results'])}'")
      return [] if response['count'] == '0'
      objects = response['results']
    rescue StandardError => e
      context.err("Error while getting list of objects: '#{e}'")
      return []
    end
    objects
  end
  def get_pulp_href(name, context)
    context.notice("Getting pulp href of '#{name}'")
    begin
      res = RestClient.get "#{@uri}#{@endpoint}?name=#{name}",
        { content_type: :json, accept: :json }
      response = JSON.parse(res)
      pulp_href = response['results'][0]['pulp_href']
      context.notice("The pulp href of #{name} is #{pulp_href}")
    rescue StandardError => e
      context.err("Error getting pulp href of object: '#{e}'")
    end 
    pulp_href
  end
end
