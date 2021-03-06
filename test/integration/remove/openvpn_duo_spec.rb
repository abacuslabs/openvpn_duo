# encoding: utf-8
# frozen_string_literal: true

require_relative 'spec_helper'

control 'openvpn_duo' do
  impact 1.0
  title 'OpenVPN Duo: Plugin is uninstalled'
  desc 'The OpenVPN Duo plugin is uninstalled'

  case os[:family]
  when 'debian'
    describe apt('https://packagecloud.io/socrata-platform/duo-openvpn/' \
                 'ubuntu') do
      it 'does not exist' do
        expect(subject).to_not exist
      end
    end
  when 'rhel'
    describe yum.repo('socrata-platform_duo-openvpn') do
      it 'does not exist' do
        expect(subject).to_not exist
      end
    end
  end

  describe package('duo-openvpn') do
    it 'is not installed' do
      expect(subject).to_not be_installed
    end
  end

  describe file('/etc/openvpn/server.conf') do
    it 'does not have the Duo plugin configured' do
      r = Regexp.new('^plugin /usr/lib/openvpn/plugins/duo/duo_openvpn\\.so ' \
                     'int123 secabc example\\.com$')
      expect(subject.content).to_not match(r)
    end
  end
end
