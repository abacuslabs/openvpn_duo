# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'openvpn_duo::default' do
  %i(integration_key secret_key hostname).each { |a| let(a) { nil } }
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      %i(integration_key secret_key hostname).each do |a|
        node.normal['openvpn_duo'][a] = send(a) unless send(a).nil?
      end
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  context 'all required attributes set' do
    let(:integration_key) { '12345' }
    let(:secret_key) { 'abc123' }
    let(:hostname) { 'example.com' }

    it 'includes the openvpn cookbook' do
      expect(chef_run).to include_recipe('openvpn')
    end

    it 'modifies the openvpn service resource' do
      expect(chef_run.service('openvpn')).to do_nothing
    end

    it 'uses a log resource to notify the openvpn service' do
      l = 'Perform OpenVPN service actions delayed by openvpn_duo'
      expect(chef_run).to write_log(l)
      expect(chef_run.log(l)).to notify('service[openvpn]').to(:enable)
      expect(chef_run.log(l)).to notify('service[openvpn]').to(:start)
    end

    it 'installs the OpenVPN Duo plugin' do
      expect(chef_run).to install_openvpn_duo('default')
        .with(integration_key: integration_key,
              secret_key: secret_key,
              hostname: hostname)
    end

    it 'enables the OpenVPN Duo plugin' do
      expect(chef_run).to enable_openvpn_duo('default')
        .with(integration_key: integration_key,
              secret_key: secret_key,
              hostname: hostname)
    end
  end
end
