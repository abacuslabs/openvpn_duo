Openvpn_Duo Cookbook
====================
[![Cookbook Version](https://img.shields.io/cookbook/v/openvpn_duo.svg)][cookbook]
[![Build Status](https://img.shields.io/travis/socrata-cookbooks/openvpn_duo.svg)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/socrata-cookbooks/openvpn_duo.svg)][codeclimate]
[![Coverage Status](https://img.shields.io/coveralls/socrata-cookbooks/openvpn_duo.svg)][coveralls]

[cookbook]: https://supermarket.chef.io/cookbooks/openvpn_duo
[travis]: https://travis-ci.org/socrata-cookbooks/openvpn_duo
[codeclimate]: https://codeclimate.com/github/socrata-cookbooks/openvpn_duo
[coveralls]: https://coveralls.io/r/socrata-cookbooks/openvpn_duo

A Chef cookbook for the OpenVPN Duo plugin.

Requirements
============

This cookbook depends on the openvpn and packagecloud community cookbooks, for
the OpenVPN server itself and for the packaged version of the plugin that we
build in PackageCloud.io.

It primarily supports Ubuntu. There is support for RHEL platforms as well, but
the openvpn cookbook as currently released has some issues related to Systemd
that RHEL users will need to work around on their own.

It requires Chef 12.10.24+ or Chef 12 and the compat_resource cookbook.

Usage
=====

Either add the default recipe to your node's run list or use the included
custom resource in a recipe of your own.

Recipes
=======

***default***

Ensure the OpenVPN server is installed, patch it to delay writing the config
file and starting the service until the end of the Chef run, then install and
configure the plugin based on Chef attributes (below).

Attributes
==========

***default***

The Duo plugin requires three pieces of information to function, all of which
can be set via attributes:

    node['openvpn_duo']['integration_key']
    node['openvpn_duo']['secret_key']
    node['openvpn_duo']['hostname']

Resources
=========

***openvpn_duo***

The main resource for managing the plugin.

Syntax:

    openvpn_duo 'default' do
      integration_key '123'
      secret_key 'abcd'
      hostname 'example.com'
      action %i(install enable)
    end

Actions:

| Action     | Description                                      |
|------------|--------------------------------------------------|
| `:install` | Install the plugin package                       |
| `:enable`  | Patch the plugin into the OpenVPN server config  |
| `:remove`  | Uninstall the plugin package                     |
| `:disable` | Remove the plugin from the OpenVPN server config |

Properties:

| Property        | Default              | Description             |
|-----------------|----------------------|-------------------------|
| integration_key | `nil`                | The Duo integration key |
| secret_key      | `nil`                | The Duo secret key      |
| hostname        | `nil`                | The Duo hostname        |
| action          | `%i(install enable)` | Action(s) to perform    |

***openvpn_duo_rhel***

The RHEL implementation of the `openvpn_duo` resource.

***openvpn_duo_ubuntu***

The Ubuntu implementation of the `openvpn_duo` resource.

Contributing
============

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for the new feature; ensure they pass (`rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

License & Authors
=================
- Author: Jonathan Hartman <jonathan.hartman@socrata.com>

Copyright 2016, Socrata, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
