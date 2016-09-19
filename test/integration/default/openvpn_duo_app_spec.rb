# encoding: utf-8
# frozen_string_literal: true

require_relative 'spec_helper'

control 'openvpn_duo_app' do
  impact 1.0
  title 'OpenVPN Duo: Plugin is installed'
  desc 'The OpenVPN Duo plugin is installed'

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
end
