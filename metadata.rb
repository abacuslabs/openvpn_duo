# encoding: utf-8
# frozen_string_literal: true

name 'openvpn_duo'
maintainer 'Jonathan Hartman'
maintainer_email 'jonathan.hartman@socrata.com'
license 'apachev2'
description 'Installs/configures the OpenVPN Duo plugin'
long_description 'Installs/configures the OpenVPN Duo plugin'
version '0.0.1'

source_url 'https://github.com/socrata-cookbooks/openvpn_duo'
issues_url 'https://github.com/socrata-cookbooks/openvpn_duo/issues'

depends 'packagecloud', '~> 0.2'

supports 'ubuntu'
