# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::openvpn_duo' do
  include_context 'resources'

  let(:resource) { 'openvpn_duo' }
  let(:properties) { {} }
  let(:name) { 'default' }

  shared_examples_for 'any platform' do
    context 'the default action (:install)' do
      it 'installs the duo-openvpn package' do
        expect(chef_run).to install_package('duo-openvpn')
      end
    end
  end
end
