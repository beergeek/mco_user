# == Defined: mco_user
#
# A defined type to add a MCO client user.
#
# === Parameters
#
# [*certificate*]
#   The absolute path of the local PEM file, on the node, for the CERT.
#   No Default.
#
# [*middleware_hosts*]
#   String or an array of FQDN addresses for ActiveMQ brokers to join.
#   No Default.
#
# [*private_key*]
#   The absolute path of the local PEM file, ont he node, for the provate key.
#   No Default.
#
# [*ssl_ca_cert*]
#   The absolute path of the local PEM file, on the node, for the CA CERT.
#   No Default.
#
# [*ssl_server_public*]
#   The absolute path of the local PEM file, on the node, for the public key.
#   No Default.
#
# [*callerid*]
#   The name of the caller for the client.
#   Default is $name.
#
# [*collective*]
#   A string or array of collectives the client belongs too.
#   Default is 'mcollective'.
#
# [*confdir*]
#   The absolute path for the MCollective configuration path.
#   Defaults to '/etc/puppetlabs/mcollective'.
#
# [*core_libdir*]
#   Core library path for MCollective.
#   Defaults to '/opt/puppet/libexec/mcollective'.
#
# [*group*]
#   Group for file ownership.
#   Defaults to $name.
#
# [*homedir*]
#   Home directory of user.
#   Defaults to '/home/${username}'.
#
# [*logfile*]
#   Absolute path for the client log.
#   Defaults to 'var/lib/${username}/.mcollective.d/client.log'.
#
# [*loglevel*]
#   Loglevel for client.
#   Defaults to 'info'.
#
# [*main_collective*]
#   The main collective for the client.
#   Defaults to 'mcollective'.
#
# [*middleware_password*]
#   Password for the ActiveMQ Pool client.
#   Default is 'mcollective'.
#
# [*middleware_port*]
#   Port of the ActiveMQ Pool port.
#   Default is '61613'.
#
# [*middleware_ssl*]
#   Boolean value to determine if ActiveMQ SSL is enabled.
#   Defaults is true.
#
# [*middleware_ssl_fallback*]
#   Boolean value to determine if unverified SSL is allowed.
#   Default is false.
#
# [*middleware_user*]
#   Name of the ActiveMQ Pool user.
#   Default is $name.
#
# [*securityprovider*]
#   Name of the security provider.
#   Default is 'ssl'.
#
# [*site_libdir*]
#   Absolute path of the site library directory.
#   Default is '/usr/local/libexec/mcollective'.
#
# [*username*]
#   User name for file ownership.
#   Default is $name.
#
# === Examples
#
#  mco_user { 'peadmin':
#   certificate       => '/etc/puppetlabs/puppet/ssl/certs/pe-internal-peadmin-mcollective-client.pem',
#   middleware_hosts  => ['s0.puppetlabs.vm','s1.puppetlabs.vm'],
#   ssl_ca_cert       => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
#   ssl_server_public => '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-mcollective-servers.pem',
#   homedir           => '/var/lib/peadmin',
#   middleware_user   => 'mcollective',
#  }
#
# === Authors
#
# Brett Gray <brett.gray@puppetlabs.com>
#
# === Copyright
#
# Copyright 2014 Puppet Labs, unless otherwise stated.
#
define mco_user (
  $certificate,
  $middleware_hosts,
  $private_key,
  $ssl_ca_cert,
  $ssl_server_public,
  $callerid                 = $name,
  $collectives              = 'mcollective',
  $confdir                  = '/etc/puppetlabs/mcollective',
  $core_libdir              = '/opt/puppet/libexec/mcollective',
  $group                    = $name,
  $homedir                  = "/home/${username}",
  $logfile                  = "/var/lib/${username}/.mcollective.d/client.log",
  $loglevel                 = 'info',
  $main_collective          = 'mcollective',
  $middleware_password      = 'mcollective',
  $middleware_port          = '61613',
  $middleware_ssl           = true,
  $middleware_ssl_fallback  = false,
  $middleware_user          = $name,
  $securityprovider         = 'ssl',
  $site_libdir              = '/usr/local/libexec/mcollective',
  $username                 = $name,
) {

  if $::osfamily != 'RedHat' and $::operatingsystemmajrelease != '6' {
    fail("This module is only designed for RHEL6, not ${::osfamily}, ${::operatingsystemmajrelease}")
  }

  #validation
  validate_bool($middleware_ssl)
  validate_bool($middleware_ssl_fallback)

  #variables
  $connector = 'activemq'

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
    template => 'mco_user/settings.cfg.erb',
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

    file { "${homedir}/.mcollective.d/credentials/private_keys/${callerid}.pem":
      source => $private_key,
      owner  => $username,
      group  => $group,
      mode   => '0400',
    }

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


  mco_user::setting { 'direct_addressing':
    value => 1,
  }

  mco_user::setting { 'plugin.activemq.base64':
    value => 'yes',
  }

  mco_user::setting { 'plugin.activemq.randomize':
    value => 'true',
  }

  $pool_size = size(flatten([$middleware_hosts]))
  mco_user::setting { "${username}-plugin.activemq.pool.size":
    setting => 'plugin.activemq.pool.size',
    value   => $pool_size,
  }

  # This is specific to connector, but refers to the user's certs
  $hosts = range( '1', $pool_size )
  $connectors = prefix( $hosts, "${username}_" )
  $indexes = range('1', $pool_size)
  mco_user::hosts_iteration { $indexes:
    confdir                 => $confdir,
    homedir                 => $homedir,
    middleware_hosts        => $middleware_hosts,
    middleware_password     => $middleware_password,
    middleware_port         => $middleware_port,
    middleware_ssl          => $middleware_ssl,
    middleware_ssl_fallback => $middleware_ssl_fallback,
    middleware_user         => $middleware_user,
    username                => $username,
  }
}
