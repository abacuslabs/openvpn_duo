# encoding: utf-8
# frozen_string_literal: true

default['openvpn_duo'].tap do |o|
  o['integration_key'] = 'int123'
  o['secret_key'] = 'secabc'
  o['hostname'] = 'example.com'
end
