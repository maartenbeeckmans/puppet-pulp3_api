require 'json'
require 'erb'
require 'colorize'
require 'yaml'
require 'fileutils'

module Config
  class << self
    attr_reader :apidocbasepath, :typemap, :resourcemap, :typetemplate, :providertemplate
  end
  @apidocbasepath = 'api.json'
  @typemap = {
    'string' => 'String',
    'integer' => 'Integer',
    'boolean' => 'Boolean',
    'array' => 'Array',
    'numeric' => 'Numeric',
    'hash' => 'Hash',
  }
  # Format: "name_in_api_docs" => "name_of_resource_type"
  @resourcemap = YAML.load_file("config.yaml")
  #@resourcemap = {
  #    'rpm.RpmDistribution' => 'test_pulp_rpm_distribution',
  #    'rpm.RpmPublication' => 'test_pulp_rpm_publication',
  #    'rpm.RpmRemote' => 'test_pulp_rpm_remote',
  #    'rpm.RpmRepository' => 'test_pulp_rpm_repository'
  #}
  @typetemplate = ERB.new(File.read('type.rb.erb'), nil, '-')
  @providertemplate = ERB.new(File.read('provider.rb.erb'), nil, '-')
end

class Endpoint
  def initialize()
    begin
      api_config_file = File.open "#{Config.apidocbasepath}"
      api_config_data = JSON.load api_config_file
      api_config_file.close
    rescue
      api_config_data = {}
    end
    _generate(api_config_data)
  end

  def _print_hash(hash)
    puts JSON.pretty_generate(hash).light_blue
  end

  def _generate(api_config_hash)
    Config.resourcemap['resources'].each do |resource|
      puts '----------------------------------------'.blue
      puts "Generating resource #{resource['name']}".blue
      _gentype(resource['name'], resource['schema'], api_config_hash)
      _genprovider(resource['name'], resource['schema'], resource['endpoint'], api_config_hash)
      puts '----------------------------------------'.blue
    end
  end

  def _gentype(typename, schema, api_config_hash)
    puts "Generating type ../lib/puppet/type/#{typename}.rb".green
    typemap = Hash.new
    typemap['name'] = typename
    typemap['description'] = api_config_hash['components']['schemas'][schema]['description']
    attributearray = Array.new
    api_config_hash['components']['schemas'][schema]['properties'].each do |attribute|
      attributemap = Hash.new
      attributemap['name'] = attribute[0]
      if not attribute[1]['allOf'].nil?
        enum_link = attribute[1]['allOf'][0]['$ref'].split('/')[-1]
        enum_types = api_config_hash['components']['schemas'][enum_link]['enum']
        attributemap['type'] = "Enum#{enum_types}"
      else
        if not attribute[1]['nullable'].nil?
          attributemap['type'] = "Optional[#{Config.typemap[attribute[1]['type']]}]"
        else
          attributemap['type'] = Config.typemap[attribute[1]['type']]
        end
      end
      if not attribute[1]['description'].nil?
        attributemap['description'] = attribute[1]['description'].gsub("'", '"')
      end
      if not attribute[1]['default'].nil?
        attributemap['default'] = attribute[1]['default']
      end
      if attributemap['name'] == 'name'
        attributemap['behaviour'] = ':namevar'
      end
      attributearray << attributemap
    end
    typemap['attributes'] = attributearray
    File.open("../lib/puppet/type/#{typename}.rb", 'w') do |f|
      f.write Config.typetemplate.result(binding)
    end
  end

  def _genprovider(providername, schema, endpoint, api_config_hash)
    puts "Generating provider ../lib/puppet/provider/#{providername}/#{providername}.rb".green
    providermap = Hash.new
    providermap['name'] = providername
      .split(/ |\_|\-/).map(&:capitalize).join("")
    providermap['endpoint'] = endpoint
    attributearray = Array.new
    api_config_hash['components']['schemas'][schema]['properties'].each do |attribute|
      attributearray << attribute[0]
    end
    providermap['attributes'] = attributearray
    FileUtils.mkdir_p "../lib/puppet/provider/#{providername}"
    File.open("../lib/puppet/provider/#{providername}/#{providername}.rb", 'w') do |f|
      f.write Config.providertemplate.result(binding)
    end
  end
end

Endpoint.new

