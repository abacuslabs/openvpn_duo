# encoding: utf-8
# frozen_string_literal: true

apt_update 'default'
include_recipe 'openvpn_duo'

openvpn_duo 'default' do
  action %i(disable remove)
end
