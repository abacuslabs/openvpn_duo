# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::openvpn_duo' do
  include_context 'resources'

  %i(integration_key secret_key hostname).each { |p| let(p) { nil } }
  let(:resource) { 'openvpn_duo' }
  let(:properties) do
    {
      integration_key: integration_key,
      secret_key: secret_key,
      hostname: hostname
    }
  end
  let(:name) { 'default' }

  shared_context 'the default action (:install, :enable)' do
    let(:integration_key) { 'int123' }
    let(:secret_key) { 'secabc' }
    let(:hostname) { 'example.com' }
  end

  shared_context 'the :install action' do
    let(:action) { :install }
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_context 'the :enable action' do
    let(:action) { :enable }
    let(:integration_key) { 'int123' }
    let(:secret_key) { 'secabc' }
    let(:hostname) { 'example.com' }
  end

  shared_context 'the :disable action' do
    let(:action) { :disable }
  end

  shared_examples_for 'any platform' do
    context 'the default action (:install, :enable)' do
      include_context description

      it 'declares a new openvpn_duo resource' do
        expect(chef_run).to install_openvpn_duo(name)
        expect(chef_run).to enable_openvpn_duo(name)
      end

      it 'installs the duo-openvpn package' do
        expect(chef_run).to install_package('duo-openvpn')
      end

      it 'includes the openvpn cookbook' do
        expect(chef_run).to include_recipe('openvpn')
      end

      it 'adds the duo plugin to the OpenVPN config' do
        expect(chef_run.openvpn_conf('server').plugins).to eq(
          ['/usr/lib/openvpn/plugins/duo/duo_openvpn.so int123 secabc ' \
           'example.com']
        )
      end
    end

    context 'the :install action' do
      include_context description

      it 'declares a new openvpn_duo resource' do
        expect(chef_run).to install_openvpn_duo(name)
      end

      it 'installs the duo-openvpn package' do
        expect(chef_run).to install_package('duo-openvpn')
      end
    end

    context 'the :enable action' do
      include_context description

      context 'all required properties set' do
        it 'declares a new openvpn_duo resource' do
          expect(chef_run).to enable_openvpn_duo(name)
        end

        it 'includes the openvpn cookbook' do
          expect(chef_run).to include_recipe('openvpn')
        end

        it 'adds the duo plugin to the OpenVPN config' do
          expect(chef_run.openvpn_conf('server').plugins).to eq(
            ['/usr/lib/openvpn/plugins/duo/duo_openvpn.so int123 secabc ' \
             'example.com']
          )
        end
      end

      context 'a missing integration key property' do
        let(:integration_key) { nil }

        it 'raises an error' do
          expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
        end
      end

      context 'a missing secret key property' do
        let(:secret_key) { nil }

        it 'raises an error' do
          expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
        end
      end

      context 'a missing hostname property' do
        let(:hostname) { nil }

        it 'raises an error' do
          expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
        end
      end
    end

    context 'the :remove action' do
      include_context description

      it 'declares a new openvpn_duo resource' do
        expect(chef_run).to remove_openvpn_duo(name)
      end
    end

    context 'the :disable action' do
      include_context description

      it 'declares a new openvpn_duo resource' do
        expect(chef_run).to disable_openvpn_duo(name)
      end

      it 'includes the openvpn cookbook' do
        expect(chef_run).to include_recipe('openvpn')
      end

      it 'does not add the Duo plugin to the OpenVPN config' do
        expect(chef_run.openvpn_conf('server').plugins).to eq([])
      end
    end
  end
end
