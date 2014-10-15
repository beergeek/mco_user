require 'spec_helper'
describe 'mco_user::hosts_iteration' do

  context 'For peadmin user with normal parameters' do
    let(:facts) {
      {
        :caller_module_name => 'mco_user',
      }
    }
    let(:params) {
      {
        :callerid                 => 'peadmin',
        :homedir                  => '/var/lib/peadmin',
        :middleware_hosts         => 'ca.puppetlabs.vm',
        :middleware_password      => 'dfjkvdfvddfvd',
        :middleware_port          => '61613',
        :middleware_ssl           => true,
        :middleware_ssl_fallback  => false,
        :middleware_user          => 'mcollective',
        :username                 => 'peadmin',
      }
    }
    let(:title) { 1 }
    let(:name) { 1 }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.host').with(
        'value'     => 'ca.puppetlabs.vm',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.user').with(
        'value'     => 'mcollective',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.password').with(
        'value'     => 'dfjkvdfvddfvd',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.ssl').with(
        'value'     => '1',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.ssl.fallback').with(
        'value'     => '0',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.ssl.ca').with(
        'value'     => '/var/lib/peadmin/.mcollective.d/credentials/certs/ca.pem',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.ssl.cert').with(
        'value'     => '/var/lib/peadmin/.mcollective.d/credentials/certs/peadmin.pem',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.ssl.key').with(
        'value'     => '/var/lib/peadmin/.mcollective.d/credentials/private_keys/peadmin.pem',
        'username'  => 'peadmin',
      )
    }

  end

  context 'For peadmin user without ssl' do
    let(:facts) {
      {
        :caller_module_name => 'mco_user',
      }
    }
    let(:params) {
      {
        :callerid                 => 'peadmin',
        :homedir                  => '/var/lib/peadmin',
        :middleware_hosts         => 'ca.puppetlabs.vm',
        :middleware_password      => 'dfjkvdfvddfvd',
        :middleware_port          => '61613',
        :middleware_ssl           => false,
        :middleware_ssl_fallback  => false,
        :middleware_user          => 'mcollective',
        :username                 => 'peadmin',
      }
    }
    let(:title) { 1 }
    let(:name) { 1 }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.host').with(
        'value'     => 'ca.puppetlabs.vm',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.user').with(
        'value'     => 'mcollective',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.password').with(
        'value'     => 'dfjkvdfvddfvd',
        'username'  => 'peadmin',
      )
    }

    it {
      should_not contain_mco_user__setting('plugin.activemq.pool.1.ssl')
    }

    it {
      should_not contain_mco_user__setting('plugin.activemq.pool.1.ssl.fallback')
    }

    it {
      should_not contain_mco_user__setting('plugin.activemq.pool.1.ssl.ca')
    }

    it {
      should_not contain_mco_user__setting('plugin.activemq.pool.1.ssl.cert')
    }

    it {
      should_not contain_mco_user__setting('plugin.activemq.pool.1.ssl.key')
    }

  end

  context 'For peadmin user with ssl fallback' do
    let(:facts) {
      {
        :caller_module_name => 'mco_user',
      }
    }
    let(:params) {
      {
        :callerid                 => 'peadmin',
        :homedir                  => '/var/lib/peadmin',
        :middleware_hosts         => 'ca.puppetlabs.vm',
        :middleware_password      => 'dfjkvdfvddfvd',
        :middleware_port          => '61613',
        :middleware_ssl           => true,
        :middleware_ssl_fallback  => true,
        :middleware_user          => 'mcollective',
        :username                 => 'peadmin',
      }
    }
    let(:title) { 1 }
    let(:name) { 1 }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.host').with(
        'value'     => 'ca.puppetlabs.vm',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.user').with(
        'value'     => 'mcollective',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.password').with(
        'value'     => 'dfjkvdfvddfvd',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.ssl').with(
        'value'     => '1',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.ssl.fallback').with(
        'value'     => '1',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.ssl.ca').with(
        'value'     => '/var/lib/peadmin/.mcollective.d/credentials/certs/ca.pem',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.ssl.cert').with(
        'value'     => '/var/lib/peadmin/.mcollective.d/credentials/certs/peadmin.pem',
        'username'  => 'peadmin',
      )
    }

    it {
      should contain_mco_user__setting('plugin.activemq.pool.1.ssl.key').with(
        'value'     => '/var/lib/peadmin/.mcollective.d/credentials/private_keys/peadmin.pem',
        'username'  => 'peadmin',
      )
    }

  end
end
