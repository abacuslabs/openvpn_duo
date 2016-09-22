# encoding: utf-8
# frozen_string_literal: true

require_relative 'spec_helper'

control 'openvpn_duo' do
  impact 1.0
  title 'OpenVPN Duo: Plugin is installed and configured'
  desc 'The OpenVPN Duo plugin is installed and configured'

  describe apt('https://packagecloud.io/socrata-platform/duo-openvpn/ubuntu') do
    it 'exists' do
      expect(subject).to exist
    end

    it 'is enabled' do
      expect(subject).to be_enabled
    end
  end

  describe package('duo-openvpn') do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end

  describe file('/etc/openvpn/server.conf') do
    it 'has the Duo plugin configured' do
      r = Regexp.new('^plugin /usr/lib/openvpn/plugins/duo/duo_openvpn\\.so ' \
                     'int123 secabc example\\.com$')
      expect(subject.content).to match(r)
    end
  end
end
