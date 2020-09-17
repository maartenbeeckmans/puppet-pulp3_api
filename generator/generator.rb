require 'json'
require 'erb'
require 'colorize'

# Functions
def open_json(path)
  api_config_file = File.open path
  api_config_data = JSON.load api_config_file
  api_config_file.close
  api_config_data
end

def print_hash(hash)
  puts JSON.pretty_generate(hash)
end

def gentypes(types_hash, components_hash)
  types_hash.each do |type|
    puts "#{type[0]} => #{type[1]}"
  end
end

def gentype(type)
end


# Variables
path='api.json'
resources_hash = {
  "rpm.RpmDistribution" => "test_pulp_rpm_distribution",
  "rpm.RpmPublication" => "test_pulp_rpm_publication",
  "rpm.RpmRemote" => "test_pulp_rpm_remote",
  "rpm.RpmRepository" => "test_pulp_rpm_repository"
}


api_config_data = open_json(path)
components = api_config_data["components"]["schemas"]
gentypes(resources_hash, components)

#foo.each do |bar|
#  puts "Printing hash of #{bar}".red
#  print_hash components[bar]
#end
#cmp_hash = components["rpm.RpmRepository"]

#prop_hash = cmp_hash["properties"]
#req_array = cmp_hash["required"]
#
#prop_hash.each do |prop|
#  key = prop[0]
#  value = prop[1]
#  if req_array.include? key
#    value["required"] = true
#  end
#  puts "#{key} => #{JSON.pretty_generate(value)}"
#end
