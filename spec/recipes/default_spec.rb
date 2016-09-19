# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'openvpn_duo::default' do
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) { ChefSpec::SoloRunner.new(platform) }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'installs the OpenVPN Duo plugin' do
    expect(chef_run).to install_openvpn_duo('default')
  end
end
