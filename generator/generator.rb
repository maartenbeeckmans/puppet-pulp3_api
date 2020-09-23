require 'json'
require 'erb'
require 'colorize'
require 'yaml'
require 'fileutils'

module Config
  class << self
    attr_reader :apidocbasepath, :typemap, :resourcemap, :typetemplate, :providertemplate, :definedtypetemplate
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
  @definedtypetemplate = ERB.new(File.read('defined_type.pp.erb'), nil, '-')
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
      config_hash = _create_config_hash(resource, api_config_hash)
      _print_hash(config_hash)
      _gentype(config_hash)
      _genprovider(config_hash)
      _gendefinedtype(config_hash)
      puts '----------------------------------------'.blue
    end
  end

  def _create_config_hash(resource, api_config_hash)
    config_hash = Hash.new
    config_hash['name'] = resource['name']
    config_hash['providername'] = resource['name']
      .split(/ |\_|\-/).map(&:capitalize).join("")
    config_hash['endpoint'] = resource['endpoint']
    config_hash['description'] = "Resource for creating #{resource['name']}"
    attributearray = Array.new
    attributearray_namevar = Array.new
    attributearray_normal = Array.new
    attributearray_read_only = Array.new
    api_config_hash['definitions'][resource['schema']]['properties'].each do |attribute|
      attributemap = Hash.new
      attributemap['name'] = attribute[0]
      if not attribute[1]['enum'].nil?
        attributemap['type'] = "Enum#{attribute[1]['enum'].uniq}".gsub('"','')
        attributemap['default'] = attribute[1]['enum'][-1]
      else
        if not attribute[1]['x-nullable'].nil?
          attributemap['type'] = "Optional[#{Config.typemap[attribute[1]['type']]}]"
        else
          attributemap['type'] = Config.typemap[attribute[1]['type']]
        end
        if attribute[1]['type'] == 'boolean'
          attributemap['default'] = false
        end
      end
      if not attribute[1]['description'].nil?
        attributemap['description'] = attribute[1]['description'].gsub("'", '"')
      else
        attributemap['description'] = attribute[1]['title'].gsub("'", '"')
      end
      if not attribute[1]['default'].nil?
        attributemap['default'] = attribute[1]['default']
      end
      if not attribute[1]['minimum'].nil?
        attributemap['default'] = attribute[1]['minimum']
      end
      if attribute[0] == resource['namevar']
        attributemap['behaviour'] = ':namevar'
        attributearray_namevar << attributemap 
      elsif not attribute[1]['readOnly'].nil?
        attributemap['behaviour'] = ':read_only'
        attributearray_read_only << attributemap
      else
        attributearray_normal << attributemap
      end
    end
    # Ordering is important for type
    attributearray = attributearray_namevar + attributearray_normal + attributearray_read_only
    config_hash['attributes'] = attributearray
    config_hash
  end

  def _gentype(config_hash)
    puts "Generating type ../lib/puppet/type/#{config_hash['name']}.rb".green
    File.open("../lib/puppet/type/#{config_hash['name']}.rb", 'w') do |f|
      f.write Config.typetemplate.result(binding)
    end
  end

  def _genprovider(config_hash)
    puts "Generating provider ../lib/puppet/provider/#{config_hash['name']}/#{config_hash['name']}.rb".green
    FileUtils.mkdir_p "../lib/puppet/provider/#{config_hash['name']}"
    File.open("../lib/puppet/provider/#{config_hash['name']}/#{config_hash['name']}.rb", 'w') do |f|
      f.write Config.providertemplate.result(binding)
    end
  end

  def _gendefinedtype(config_hash)
    puts "Generating defined type ../manifests/#{config_hash['name']}.pp".green
    File.open("../manifests/#{config_hash['name']}.pp", 'w') do |f|
      f.write Config.definedtypetemplate.result(binding)
    end
  end
end

Endpoint.new

