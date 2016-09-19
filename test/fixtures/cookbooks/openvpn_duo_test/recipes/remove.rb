# encoding: utf-8
# frozen_string_literal: true

include_recipe 'openvpn_duo'

openvpn_duo 'default' do
  action :remove
end
