# encoding: utf-8
# frozen_string_literal: true

apt_update 'default' if node['platform_family'] == 'debian'
include_recipe 'openvpn_duo'
if node['platform_family'] == 'rhel' && node['platform_version'].to_i >= 7
  edit_resource :service, 'openvpn' do
    service_name 'openvpn@server'
  end
end
