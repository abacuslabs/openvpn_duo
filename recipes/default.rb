# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_duo
# Recipe:: default
#
# Copyright 2016, Socrata, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

attrs = node['openvpn_duo']

include_recipe 'openvpn'

edit_resource :service, 'openvpn' do
  action :nothing
end

log "Perform OpenVPN service actions delayed by #{cookbook_name}" do
  notifies :enable, 'service[openvpn]'
  notifies :start, 'service[openvpn]'
end

openvpn_duo 'default' do
  integration_key attrs['integration_key'] unless attrs['integration_key'].nil?
  secret_key attrs['secret_key'] unless attrs['secret_key'].nil?
  hostname attrs['hostname'] unless attrs['hostname'].nil?
end
