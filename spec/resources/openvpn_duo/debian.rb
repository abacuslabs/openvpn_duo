# encoding: utf-8
# frozen_string_literal: true

require_relative '../openvpn_duo'

shared_context 'resources::openvpn_duo::debian' do
  include_context 'resources::openvpn_duo'

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'

    context 'the default action (:install)' do
      it 'configures the PackageCloud APT repo' do
        expect(chef_run).to create_packagecloud_repo(
          'socrata-platform/duo-openvpn'
        ).with(type: 'deb')
      end
    end

    context 'the :remove action' do
      let(:action) { :remove }

      it 'purges the duo-openvpn package' do
        expect(chef_run).to purge_package('duo-openvpn')
      end

      it 'removes the PackageCloud APT repo' do
        expect(chef_run).to remove_apt_repository(
          'socrata-platform_duo-openvpn'
        )
      end
    end
  end
end
