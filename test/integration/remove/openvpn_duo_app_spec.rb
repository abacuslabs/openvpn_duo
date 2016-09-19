# encoding: utf-8
# frozen_string_literal: true

require_relative 'spec_helper'

control 'openvpn_duo_app' do
  impact 1.0
  title 'OpenVPN Duo: Plugin is uninstalled'
  desc 'The OpenVPN Duo plugin is uninstalled'

  describe apt('https://packagecloud.io/socrata-platform/duo-openvpn/ubuntu') do
    it 'does not exist' do
      expect(subject).to_not exist
    end
  end

  describe package('duo-openvpn') do
    it 'is not installed' do
      expect(subject).to_not be_installed
    end
  end
end
