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

require 'chef/dsl/include_recipe'
require 'chef/exceptions'
require 'chef/resource'

class Chef
  class Resource
    # A Chef custom resource for the OpenVPN Duo plugin.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class OpenvpnDuo < Resource
      include Chef::DSL::IncludeRecipe

      default_action %i(install enable)

      #
      # The plugin requires three properties for its configuration.
      #
      property :integration_key, String
      property :secret_key, String
      property :hostname, String

      #
      # If the resource is to be enabled, shove the plugin into the root run
      # context's config resource at compile time so it only gets rendered once
      # and service notifications don't happen in an impossible order.
      #
      def after_created
        Array(action).each do |act|
          case act
          when :enable
            enable_plugin_shim!
          when :disable
            disable_plugin_shim!
          end
        end
      end

      #
      # Include the OpenVPN cookbook and immediately the Duo plugin into its
      # openvpn_conf resource.
      #
      def enable_plugin_shim!
        disable_plugin_shim!
        str = "#{path} #{integration_key} #{secret_key} #{hostname}"
        resources(openvpn_conf: 'server').plugins << str
      end

      #
      # Include the OpenVPN cookbook and immediately remove the Duo plugin
      # from its openvpn_conf resource.
      #
      def disable_plugin_shim!
        include_recipe 'openvpn'
        resources(openvpn_conf: 'server').plugins.delete_if do |p|
          p.start_with?(path)
        end
      end

      #
      # Return the path to the main Duo plugin file.
      #
      # @return [String] the Duo plugin's filesystem path
      #
      def path
        '/usr/lib/openvpn/plugins/duo/duo_openvpn.so'
      end

      #
      # Install the OpenVPN Duo plugin.
      #
      action :install do
        package 'duo-openvpn'
      end

      #
      # Enable the Duo plugin by inserting it into OpenVPN's server config. The
      # actual enabling is handled by the after_created method.
      #
      action :enable do
        # These properties are only required for the :enable action.
        %i(integration_key secret_key hostname).each do |p|
          if new_resource.send(p).nil?
            raise(Chef::Exceptions::ValidationFailed,
                  "A '#{p}' property is required for the :enable action")
          end
        end
      end

      #
      # Ensure the plugin is removed from the plugins array for the OpenVPN
      # config. This action doesn't actually need to do anything, i.e. not
      # add the plugin into the run context's openvpn_conf resource.
      #
      action :disable do
      end
    end
  end
end
