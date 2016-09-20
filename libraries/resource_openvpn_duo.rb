# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_duo
# Library:: resource_openvpn_duo
#
# Copyright 2016, Socrata, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/exceptions'
require 'chef/resource'

class Chef
  class Resource
    # A Chef custom resource for the OpenVPN Duo plugin.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class OpenvpnDuo < Resource
      default_action %i(install enable)

      #
      # The plugin requires three properties for its configuration.
      #
      property :integration_key, String
      property :secret_key, String
      property :hostname, String

      #
      # Install the OpenVPN Duo plugin.
      #
      action :install do
        package 'duo-openvpn'
      end

      #
      # Enable the Duo plugin by inserting it into OpenVPN's server config.
      #
      action :enable do
        # These properties are only required for the :enable action.
        %i(integration_key secret_key hostname).each do |p|
          if new_resource.send(p).nil?
            raise(Chef::Exceptions::ValidationFailed,
                  "A '#{p}' property is required for the :enable action")
          end
        end

        p = '/usr/lib/openvpn/plugins/duo_openvpn.so ' \
            "#{new_resource.integration_key} " \
            "#{new_resource.secret_key} #{new_resource.hostname}"
        with_run_context :root do
          edit_resource :openvpn_conf, 'server' do
            plugins.include?(p) || plugins << p
            action :nothing
          end
        end
        log 'Generate the OpenVPN config with Duo enabled' do
          notifies :create, 'openvpn_conf[server]'
        end
      end

      #
      # Ensure the plugin is removed from the plugins array for the OpenVPN
      # config.
      #
      action :disable do
        with_run_context :root do
          edit_resource :openvpn_conf, 'server' do
            plugins.delete_if do |p|
              p.start_with?('/usr/lib/openvpn/plugins/duo_openvpn.so ')
            end
            action :nothing
          end
        end
        log 'Generate the OpenVPN config with Duo disabled' do
          notifies :create, 'openvpn_conf[server]'
        end
      end
    end
  end
end
