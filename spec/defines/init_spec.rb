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
    let(:params) {
      {
        :certificate          => '/etc/puppetlabs/puppet/ssl/derts/peadmin.pem',
        :homedir              => '/var/lib/peadmin',
        :middleware_hosts     => 'ca.puppetlabs.vm',
        :ssl_ca_cert          => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
        :private_key          => '/etc/puppetlabs/puppet/ssl/private_keys/peadmin.pem',
        :ssl_server_public    => '/etc/puppetlabs/puppet/ssl/certs//mcollective_server.cert.pem',
        :middleware_user      => 'mcollective',
        :middleware_password  => 'W3_L0ve_L@ur3lW00d_1PA',
      }
    }
    it { should contain_class('mco_user') }
  end
end
