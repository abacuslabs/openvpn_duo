# encoding: utf-8
# frozen_string_literal: true

require_relative '../openvpn_duo'

shared_context 'resources::openvpn_duo::rhel' do
  include_context 'resources::openvpn_duo'

  shared_examples_for 'any RHEL platform' do
    it_behaves_like 'any platform'

    context 'the default action (:install, :enable)' do
      include_context description

      it 'configures the PackageCloud YUM repo' do
        expect(chef_run).to create_packagecloud_repo(
          'socrata-platform/duo-openvpn'
        ).with(type: 'rpm')
      end
    end

    context 'the :install action' do
      include_context description

      it 'configures the PackageCloud YUM repo' do
        expect(chef_run).to create_packagecloud_repo(
          'socrata-platform/duo-openvpn'
        ).with(type: 'rpm')
      end
    end

    context 'the :remove action' do
      include_context description

      it 'removes the duo-openvpn package' do
        expect(chef_run).to remove_package('duo-openvpn')
      end

      it 'removes the PackageCloud YUM repo' do
        expect(chef_run).to remove_yum_repository(
          'socrata-platform_duo-openvpn'
        )
      end
    end
  end
end
