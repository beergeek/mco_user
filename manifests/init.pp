# == Class: mco_user
#
# Full description of class mco_user here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { mco_user:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
define mco_user (
  $username           = $name,
  $loglevel           = 'info',
  $logfile            = "/var/lib/${username}/.mcollective.d/client.log",
  $callerid           = $username,
  $group              = $username,
  $homedir            = "/home/${username}",
  $certificate        = undef,
  $private_key        = undef,
  $main_collective    = 'mcollective',
  $collectives        = 'mcollective',
  $ssl_ca_cert        = undef,
  $ssl_server_public  = undef,
  $middleware_hosts   = undef,
  $middleware_ssl     = true,
  $securityprovider   = 'ssl',
  $connector          = 'activemq',
  $core_libdir        = '/opt/puppet/libexec/mcollective',
  $site_libdir        = '/usr/local/libexec/mcollective',
  $middleware_password           = undef,
  $middleware_user = $name,
  $middleware_ssl_port = '61613',
  $middleware_port = '61613',
  $middleware_ssl_fallback = false,
  $confdir = '/etc/puppetlabs/mcollective',
) {


notify { $username: }
  file { [
    "${homedir}/.mcollective.d",
    "${homedir}/.mcollective.d/credentials",
    "${homedir}/.mcollective.d/credentials/certs",
    "${homedir}/.mcollective.d/credentials/private_keys"
  ]:
    ensure => 'directory',
    owner  => $username,
    group  => $group,
  }

  datacat { "mco_user ${username}":
    path     => "${homedir}/.mcollective",
    collects => "mcollective::user ${username}",
    owner    => $username,
    group    => $group,
    mode     => '0400',
    template => 'mcollective/settings.cfg.erb',
  }

  Mco_user::Setting {
    username => $username,
  }

  mco_user::setting { 'logfile':
    value => $logfile,
  }

  mco_user::setting { 'loglevel':
    value => $loglevel,
  }

  mco_user::setting { 'libdir':
    value => "${site_libdir}:${core_libdir}",
  }

  mco_user::setting { 'connector':
    value => $connector,
  }

  mco_user::setting { 'securityprovider':
    value => $securityprovider,
  }

  mco_user::setting { 'collectives':
    value => join(flatten([$collectives]), ','),
  }

  mco_user::setting { 'main_collective':
    value => $main_collective,
  }

  mco_user::setting { 'factsource':
    value => 'yaml',
  }

  mco_user::setting { 'plugin.yaml':
    value => '/etc/puppetlabs/mcollective/facts.yaml',
  }

  if $middleware_ssl or $securityprovider == 'ssl' {
    file { "${homedir}/.mcollective.d/credentials/certs/ca.pem":
      source => $ssl_ca_cert,
      owner  => $username,
      group  => $group,
      mode   => '0444',
    }

    file { "${homedir}/.mcollective.d/credentials/certs/server_public.pem":
      source => $ssl_server_public,
      owner  => $username,
      group  => $group,
      mode   => '0444',
    }

    $private_path = "${homedir}/.mcollective.d/credentials/private_keys/${callerid}.pem"
    file { $private_path:
      source => $private_key,
      owner  => $username,
      group  => $group,
      mode   => '0400',
    }
  }

  if $securityprovider == 'ssl' {
    file { "${homedir}/.mcollective.d/credentials/certs/${callerid}.pem":
      source => $certificate,
      owner  => $username,
      group  => $group,
      mode   => '0444',
    }

    mco_user::setting {'plugin.ssl_serializer':
      setting => 'plugin.ssl_serializer',
      value   => 'yaml',
    }

    mco_user::setting { "${username}:plugin.ssl_client_public":
      setting  => 'plugin.ssl_client_public',
      value    => "${homedir}/.mcollective.d/credentials/certs/${callerid}.pem",
      order    => '60',
    }

    mco_user::setting { "${username}:plugin.ssl_client_private":
      setting  => 'plugin.ssl_client_private',
      value    => "${homedir}/.mcollective.d/credentials/private_keys/${callerid}.pem",
      order    => '60',
    }

    mco_user::setting { "${username}:plugin.ssl_server_public":
      setting  => 'plugin.ssl_server_public',
      value    => "${homedir}/.mcollective.d/credentials/certs/server_public.pem",
      order    => '60',
    }
  }

  if $connector == 'activemq' {
    # This is specific to connector, but refers to the user's certs
    $pool_size = size(flatten([$middleware_hosts]))
    $hosts = range( '1', $pool_size )
    $connectors = prefix( $hosts, "${username}_" )
    class { 'mco_user::activemq':
      callerid       => $callerid,
      confdir => $confdir,
      connector      => $connector,
      homedir        => $homedir,
      middleware_hosts => $middleware_hosts,
      middleware_password => $middleware_password,
      middleware_port => $middleware_port,
      middleware_ssl => $middleware_ssl,
      middleware_ssl_fallback => $middleware_ssl_fallback,
      middleware_ssl_port => $middleware_ssl_port,
      middleware_user => $middleware_user,
      order          => '60',
      username       => $username,
    }
  }
}
