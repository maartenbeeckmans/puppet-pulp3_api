# frozen_string_literal: true

require 'spec_helper'
require 'puppet/type/pulp3_rpm_remote'

RSpec.describe 'the pulp3_rpm_remote type' do
  it 'loads' do
    expect(Puppet::Type.type(:pulp3_rpm_remote)).not_to be_nil
  end
end
