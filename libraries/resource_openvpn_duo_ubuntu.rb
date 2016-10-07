# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_duo
# Library:: resource_openvpn_duo_ubuntu
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

require_relative 'resource_openvpn_duo'

class Chef
  class Resource
    # A Chef custom resource for the OpenVPN Duo plugin for Ubuntu.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class OpenvpnDuoUbuntu < OpenvpnDuo
      provides :openvpn_duo, platform: 'ubuntu'

      #
      # Install the OpenVPN Duo plugin.
      #
      action :install do
        packagecloud_repo('socrata-platform/duo-openvpn') { type 'deb' }
        super()
      end

      #
      # Remove the OpenVPN Duo plugin.
      #
      action :remove do
        package('duo-openvpn') { action :purge }
        apt_repository('socrata-platform_duo-openvpn') { action :remove }
      end
    end
  end
end
