require 'spec_helper'
describe 'mco_user' do

  context 'For peadmin user with normal parameters' do
    let(:facts) {
      {
        :osfamily                   => 'RedHat',
        :operatingsystemmajrelease  => '6',
      }
    }
    let(:title) { 'peadmin' }
    let(:name) { 'peadmin' }
    let(:params) {
      {
        :certificate          => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem',
        :homedir              => '/var/lib/peadmin',
        :middleware_hosts     => 'ca.puppetlabs.vm',
        :middleware_password  => 'W3_L0ve_L@ur3lW00d_1PA',
        :middleware_user      => 'mcollective',
        :private_key          => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem',
        :public_key           => '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-peadmin-mcollective-client.pem',
        :ssl_ca_cert          => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
        :ssl_server_public    => '/etc/puppetlabs/puppet/ssl/certs/pe-internal-mcollective-servers.pem',
      }
    }
    [
      '/var/lib/peadmin/.mcollective.d',
      '/var/lib/peadmin/.mcollective.d/credentials',
      '/var/lib/peadmin/.mcollective.d/credentials/certs',
      '/var/lib/peadmin/.mcollective.d/credentials/private_keys'
    ].each do |directory_entry|
      it {
        should contain_file("#{directory_entry}").with(
          'ensure'  => 'directory',
          'owner'   => 'peadmin',
          'group'   => 'peadmin',
          'mode'    => '700',
        )
      }
    end

    it {
      should contain_datacat('mco_user peadmin').with(
        'path'      => '/var/lib/peadmin/.mcollective',
        'collects'  => 'mcollective::user peadmin',
        'owner'     => 'peadmin',
        'group'     => 'peadmin',
        'mode'      => '0400',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:logfile').with(
        'setting'   => 'logfile',
        'value'     => '/var/lib/peadmin/.mcollective.d/client.log',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:loglevel').with(
        'setting'   => 'loglevel',
        'value'     => 'info',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:libdir').with(
        'setting'   => 'libdir',
        'value'     => '/usr/local/libexec/mcollective:/opt/puppet/libexec/mcollective',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:connector').with(
        'setting'   => 'connector',
        'value'     => 'activemq',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:collectives').with(
        'setting'   => 'collectives',
        'value'     => 'mcollective',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:main_collective').with(
        'setting'   => 'main_collective',
        'value'     => 'mcollective',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:factsource').with(
        'setting'   => 'factsource',
        'value'     => 'yaml',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:plugin.yaml').with(
        'setting'   => 'plugin.yaml',
        'value'     => '/etc/puppetlabs/mcollective/facts.yaml',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_file('/var/lib/peadmin/.mcollective.d/credentials/certs/ca.pem').with(
        'ensure'  => 'file',
        'source'  => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
        'owner'   => 'peadmin',
        'group'   => 'peadmin',
        'mode'    => '0444',
      )
    }

    it {
      should contain_file('/var/lib/peadmin/.mcollective.d/credentials/certs/server_public.pem').with(
        'ensure'  => 'file',
        'source'  => '/etc/puppetlabs/puppet/ssl/certs/pe-internal-mcollective-servers.pem',
        'owner'   => 'peadmin',
        'group'   => 'peadmin',
        'mode'    => '0444',
      )
    }

    it {
      should contain_file('/var/lib/peadmin/.mcollective.d/credentials/private_keys/peadmin.pem').with(
        'ensure'  => 'file',
        'source'  => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem',
        'owner'   => 'peadmin',
        'group'   => 'peadmin',
        'mode'    => '0400',
      )
    }

    it {
      should contain_file('/var/lib/peadmin/.mcollective.d/credentials/certs/peadmin.pem').with(
        'ensure'  => 'file',
        'source'  => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem',
        'owner'   => 'peadmin',
        'group'   => 'peadmin',
        'mode'    => '0444',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:plugin.ssl_serializer').with(
        'setting'   => 'plugin.ssl_serializer',
        'value'     => 'yaml',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:plugin.ssl_client_public').with(
        'setting'   => 'plugin.ssl_client_public',
        'value'     => '/var/lib/peadmin/.mcollective.d/credentials/public_keys/peadmin.pem',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:plugin.ssl_client_private').with(
        'setting'   => 'plugin.ssl_client_private',
        'value'     => '/var/lib/peadmin/.mcollective.d/credentials/private_keys/peadmin.pem',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:plugin.ssl_server_public').with(
        'setting'   => 'plugin.ssl_server_public',
        'value'     => '/var/lib/peadmin/.mcollective.d/credentials/certs/server_public.pem',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:direct_addressing').with(
        'setting'   => 'direct_addressing',
        'value'     => '1',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:plugin.activemq.randomize').with(
        'setting'   => 'plugin.activemq.randomize',
        'value'     => 'false',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:discovery_timeout').with(
        'setting'   => 'discovery_time',
        'value'     => '5',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:plugin.activemq.base64').with(
        'setting'   => 'plugin.activemq.base64',
        'value'     => 'yes',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:plugin.activemq.pool.size').with(
        'setting'   => 'plugin.activemq.pool.size',
        'value'     => '1',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__hosts_iteration('1').with(
        'callerid'                => 'peadmin',
        'homedir'                 => '/var/lib/peadmin',
        'middleware_hosts'        => 'ca.puppetlabs.vm',
        'middleware_password'     => 'W3_L0ve_L@ur3lW00d_1PA',
        'middleware_port'         => '61613',
        'middleware_ssl'          => true,
        'middleware_ssl_fallback' => false,
        'middleware_user'         => 'mcollective',
        'username'                => 'peadmin',
      )
    }
  end

  context 'Wrong OS' do
    let(:facts) {
      {
        :osfamily                   => 'Debian',
        :operatingsystemmajrelease  => '6',
      }
    }
    let(:title) { 'peadmin' }
    let(:name) { 'peadmin' }
    let(:params) {
      {
        :certificate          => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem',
        :homedir              => '/var/lib/peadmin',
        :middleware_hosts     => 'ca.puppetlabs.vm',
        :middleware_password  => 'W3_L0ve_L@ur3lW00d_1PA',
        :middleware_user      => 'mcollective',
        :private_key          => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem',
        :public_key           => '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-peadmin-mcollective-client.pem',
        :ssl_ca_cert          => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
        :ssl_server_public    => '/etc/puppetlabs/puppet/ssl/certs/pe-internal-mcollective-servers.pem',
      }
    }

    it {
      expect {
        should contain_file('/var/lib/peadmin/.mcollective.d')
      }.to raise_error(Puppet::Error, /This module is only designed for RHEL6, not Debian/)
    }
  end

  context 'Wrong OS release' do
    let(:facts) {
      {
        :osfamily                   => 'RedHat',
        :operatingsystemmajrelease  => '5',
      }
    }
    let(:title) { 'peadmin' }
    let(:name) { 'peadmin' }
    let(:params) {
      {
        :certificate          => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem',
        :homedir              => '/var/lib/peadmin',
        :middleware_hosts     => 'ca.puppetlabs.vm',
        :middleware_password  => 'W3_L0ve_L@ur3lW00d_1PA',
        :middleware_user      => 'mcollective',
        :private_key          => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem',
        :public_key           => '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-peadmin-mcollective-client.pem',
        :ssl_ca_cert          => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
        :ssl_server_public    => '/etc/puppetlabs/puppet/ssl/certs/pe-internal-mcollective-servers.pem',
      }
    }

    it {
      expect {
        should contain_file('/var/lib/peadmin/.mcollective.d')
      }.to raise_error(Puppet::Error, /This module is only designed for RHEL6, not RHEL5/)
    }
  end

  context 'For peadmin user without ssl' do
    let(:facts) {
      {
        :osfamily                   => 'RedHat',
        :operatingsystemmajrelease  => '6',
      }
    }
    let(:title) { 'peadmin' }
    let(:name) { 'peadmin' }
    let(:params) {
      {
        :certificate          => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem',
        :homedir              => '/var/lib/peadmin',
        :middleware_hosts     => 'ca.puppetlabs.vm',
        :middleware_password  => 'W3_L0ve_L@ur3lW00d_1PA',
        :middleware_user      => 'mcollective',
        :middleware_ssl       => false,
        :private_key          => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem',
        :public_key           => '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-peadmin-mcollective-client.pem',
        :ssl_ca_cert          => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
        :securityprovider     => nil,
        :ssl_server_public    => '/etc/puppetlabs/puppet/ssl/certs/pe-internal-mcollective-servers.pem',
      }
    }
    [
      '/var/lib/peadmin/.mcollective.d',
      '/var/lib/peadmin/.mcollective.d/credentials',
      '/var/lib/peadmin/.mcollective.d/credentials/certs',
      '/var/lib/peadmin/.mcollective.d/credentials/private_keys'
    ].each do |directory_entry|
      it {
        should contain_file("#{directory_entry}").with(
          'ensure'  => 'directory',
          'owner'   => 'peadmin',
          'group'   => 'peadmin',
          'mode'    => '700',
        )
      }
    end

    it {
      should contain_datacat('mco_user peadmin').with(
        'path'      => '/var/lib/peadmin/.mcollective',
        'collects'  => 'mcollective::user peadmin',
        'owner'     => 'peadmin',
        'group'     => 'peadmin',
        'mode'      => '0400',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:logfile').with(
        'setting'   => 'logfile',
        'value'     => '/var/lib/peadmin/.mcollective.d/client.log',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:loglevel').with(
        'setting'   => 'loglevel',
        'value'     => 'info',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:libdir').with(
        'setting'   => 'libdir',
        'value'     => '/usr/local/libexec/mcollective:/opt/puppet/libexec/mcollective',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:connector').with(
        'setting'   => 'connector',
        'value'     => 'activemq',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:collectives').with(
        'setting'   => 'collectives',
        'value'     => 'mcollective',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:main_collective').with(
        'setting'   => 'main_collective',
        'value'     => 'mcollective',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:factsource').with(
        'setting'   => 'factsource',
        'value'     => 'yaml',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:plugin.yaml').with(
        'setting'   => 'plugin.yaml',
        'value'     => '/etc/puppetlabs/mcollective/facts.yaml',
        'username'  => 'peadmin',
      )
    }

    it {
      should_not contain_file('/var/lib/peadmin/.mcollective.d/credentials/certs/ca.pem')
    }

    it {
      should_not contain_file('/var/lib/peadmin/.mcollective.d/credentials/certs/server_public.pem')
    }

    it {
      should_not contain_file('/var/lib/peadmin/.mcollective.d/credentials/private_keys/peadmin.pem')
    }

    it {
      should_not contain_file('/var/lib/peadmin/.mcollective.d/credentials/certs/peadmin.pem')
    }

    it {
      should_not contain_mco_user__setting('peadmin:plugin.ssl_serializer')
    }

    it {
      should_not contain_mco_user__setting('peadmin:plugin.ssl_client_public')
    }

    it {
      should_not contain_mco_user__setting('peadmin:plugin.ssl_client_private')
    }

    it {
      should_not contain_mco_user__setting('peadmin:plugin.ssl_server_public')
    }

    it {
      should contain_mco_user__setting('peadmin:direct_addressing').with(
        'setting'   => 'direct_addressing',
        'value'     => '1',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:plugin.activemq.randomize').with(
        'setting'   => 'plugin.activemq.randomize',
        'value'     => 'false',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('peadmin:plugin.activemq.pool.size').with(
        'setting'   => 'plugin.activemq.pool.size',
        'value'     => '1',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__hosts_iteration('1').with(
        'callerid'                => 'peadmin',
        'homedir'                 => '/var/lib/peadmin',
        'middleware_hosts'        => 'ca.puppetlabs.vm',
        'middleware_password'     => 'W3_L0ve_L@ur3lW00d_1PA',
        'middleware_port'         => '61613',
        'middleware_ssl'          => true,
        'middleware_ssl_fallback' => false,
        'middleware_user'         => 'mcollective',
        'username'                => 'peadmin',
      )
    }
  end
end
