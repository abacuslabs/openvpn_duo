# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: openvpn_duo
# Library:: matchers
#
# Copyright 2016, Socrata, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if defined?(ChefSpec)
  {
    openvpn_duo: %i(install remove enable disable)
  }.each do |matcher, actions|
    ChefSpec.define_matcher(matcher)

    actions.each do |action|
      define_method("#{action}_#{matcher}") do |name|
        ChefSpec::Matchers::ResourceMatcher.new(matcher, action, name)
      end
    end
  end
end
