# 
# This provider is automatically generated
#
# frozen_string_literal: true

require 'puppet/resource_api/simple_provider'
require 'json'
require 'uri'
#require 'yaml'

class Puppet::Provider::Pulp3RpmPublication::Pulp3RpmPublication
  def initialize
    #settings = YAML.load_file('/etc/pulpapi.yaml').symbolize_keys
    #@apiuser = settings['apiuser']
    #@apipass = settings['apipass']
    #@apihost = settings['apihost']
    #@apiport = settings['apiport']
    @apiuser = 'admin'
    @apipass = 'adminpassword'
    @apihost = 'pulp.xxs.vagrant'
    @apiport = '24817'
    @endpoint = '/pulp/api/v3/publications/rpm/rpm/'
    @property_hash = []
    @repository_endpoint = '/pulp/api/v3/repositories/rpm/rpm/'
    @repository_hash = []
  end

  def get(context)
    if @repository_hash.empty?
      parsed_objects = []
      get_pulp_objects(context, @repository_endpoint).each do |repository|
        repo_hash = Hash.new
        repo_hash['name'] = repository['name']
        repo_hash['pulp_href'] = repository['pulp_href']
        repo_hash['latest_version_href'] = repository['latest_version_href']
        parsed_objects << repo_hash
      end
      context.debug("Retrieved the following repositories: #{JSON.pretty_generate(parsed_objects)}")
      @repository_hash = parsed_objects
    end
    if @property_hash.empty?
      parsed_objects = []
      get_pulp_objects(context).each do |object|
        context.debug("Publications before translation: #{JSON.pretty_generate(object)}")
        remote = build_hash(object)
        parsed_objects << remote
      end
      context.debug("Retrieved the following publications: #{JSON.pretty_generate(parsed_objects)}")
      @property_hash = parsed_objects
    end
    @property_hash
  end

  def set(context,changes)
    changes.each do |name, change|
      # Translate latest to repository_latest_version number
      repository = find_repository_name(name[:repository_name])
      if name[:repository_version] == 'latest'
        name[:repository_version] = repository['latest_version_href'].split('/').last
      end
      if change[:is][:repository_version] == 'latest'
        change[:is][:repository_version] = repository['latest_version_href'].split('/').last
      end
      if change[:should][:repository_version] == 'latest'
        change[:should][:repository_version] = repository['latest_version_href'].split('/').last
      end

      context.notice("changes: #{change}")

      publication_exists = false
      @property_hash.each do |publication|
        if publication[:repository_name] == change[:should][:repository_name]
          if publication[:repository_version] == change[:should][:repository_version]
            context.notice("Publication for repository #{change[:should][:repository_name]} and version #{change[:should][:repository_version]} already exists")
            publication_exists = true
          end
        end
      end
      break if publication_exists

      is = if context.type.feature?('simple_get_filter')
             change.key?(:is) ? change[:is] : (get(context, [name]) || []).find { |r| r[:name] == name }
           else
             change.key?(:is) ? change[:is] : (get(context) || []).find { |r| r[:name] == name }
           end
      context.type.check_schema(is) unless change.key?(:is)

      should = change[:should]

      raise 'SimpleProvider cannot be used with a Type that is not ensurable' unless context.type.ensurable?

      is = SimpleProvider.create_absent(:name, name) if is.nil?
      should = SimpleProvider.create_absent(:name, name) if should.nil?

      name_hash = if context.type.namevars.length > 1
                    # pass a name_hash containing the values of all namevars
                    name_hash = {}
                    context.type.namevars.each do |namevar|
                      name_hash[namevar] = change[:should][namevar]
                    end
                    name_hash
                  else
                    name
                  end

      if is[:ensure].to_s == 'absent' && should[:ensure].to_s == 'present'
        context.creating(name) do
          create(context, name_hash, should)
        end
      elsif is[:ensure].to_s == 'present' && should[:ensure].to_s == 'present'
        context.updating(name) do
          update(context, name_hash, should)
        end
      elsif is[:ensure].to_s == 'present' && should[:ensure].to_s == 'absent'
        context.deleting(name) do
          delete(context, name_hash)
        end
      end
    end
  end

  def create(context, name, should)
    context.debug("Creating '#{name}' with #{should.inspect}")
    data = instance_to_hash(should)
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
    data = instance_to_hash(should)
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

  # parser functions
  def build_hash(object)
    repository = find_repository(object['repository'])
    hash = Hash.new
    hash[:ensure] = 'present'
    hash[:repository_name] = repository['name']
    hash[:repository_version] = Integer(object['repository_version'].split('/').last)
    hash[:repository_latest_version] = Integer(repository['latest_version_href'].split('/').last)
    hash[:metadata_checksum_type] = object['metadata_checksum_type']
    hash[:package_checksum_type] = object['package_checksum_type']
    hash[:pulp_href] = object['pulp_href']
    hash[:pulp_created] = object['pulp_created']
    hash
  end

  def instance_to_hash(should)
    hash = Hash.new
    repository = find_repository_name(should[:repository_name])
    hash['repository_version'] = "#{repository['pulp_href']}#{should[:repository_version]}/"
    hash['metadata_checksum_type'] = should[:metadata_checksum_type]
    hash['package_checksum_type'] = should[:package_checksum_type]
    hash['pulp_href'] = should[:pulp_href]
    hash['pulp_created'] = should[:pulp_created]
    hash
  end

  # helper methods
  def find_repository(repository_href)
    @repository_hash.each do |repository|
      if repository['pulp_href'] == repository_href
        return repository
      end
    end
    return nil
  end
  def find_repository_name(repository_name)
    @repository_hash.each do |repository|
      if repository['name'] == repository_name
        return repository
      end
    end
    return nil
  end
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

  def get_pulp_objects(context, endpoint=@endpoint)
    begin
      response = request(endpoint)
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
