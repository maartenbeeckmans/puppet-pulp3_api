# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'

require 'rubygems'
require 'rest-client'
require 'json'

# Implementation for the pulp3_rpm_remote type using the Resource API.
class Puppet::Provider::Pulp3RpmRemote::Pulp3RpmRemote < Puppet::ResourceApi::SimpleProvider
  @apiuser = 'admin'
  @apipass = 'adminpassword'
  @apihost = 'pulp.xxs.vagrant'
  @apiport = '24817'
  @uri = "http://#{@apiuser}:#{@apipass}@#{@apihost}:#{@apiport}"
  @endpoint = '/pulp/api/v3/remotes/rpm/rpm/'

  def get(context)
    context.debug('Returning pre-canned example data')
    [
      {
        name: 'foo',
        ensure: 'present',
      },
      {
        name: 'bar',
        ensure: 'present',
      },
    ]
  end

  def create(context, name, should)
    context.notice("Creating '#{name}' with #{should.inspect}")
    context.notice("Parameter name: #{should[:name]}")
    data = { 'name' => should[:name],
             'url'  => should[:url], }
    begin
      context.notice("The uri is #{@uri}#{@endpoint}")
      response = RestClient.post "#{@uri}#{@endpoint}",
        data.to_json
      context.notice("The REST API Post response is #{response}")
    rescue StandardError => e
      context.err("Creating remote '#{name}' failed with: #{e}")
    end
  end

  def update(context, name, should)
    context.notice("Updating '#{name}' with #{should.inspect}")
  end

  def delete(context, name)
    context.notice("Deleting '#{name}'")
  end
end
