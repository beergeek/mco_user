class mco_user::activemq (
  $callerid,
  $confdir,
  $connector,
  $homedir,
  $middleware_hosts,
  $middleware_ssl,
  $order,
  $username,
  $middleware_password,
  $middleware_port,
  $middleware_hosts,
  $middleware_user,
  $middleware_ssl,
  $middleware_ssl_fallback,
  $middleware_ssl_port,
) {

  Mco_user::Setting {
    username => $username,
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
  mco_user::setting { 'plugin.activemq.pool.size':
    value => $pool_size,
  }

  $i = regsubst($title, "^${username}_", '')

  if $middleware_ssl {
    mco_user::setting { "${username} plugin.${connector}.pool.${i}.ssl.ca":
      setting  => "plugin.${connector}.pool.${i}.ssl.ca",
      username => $username,
      order    => $order,
      value    => "${homedir}/.mcollective.d/credentials/certs/ca.pem",
    }

    mco_user::setting { "${username} plugin.${connector}.pool.${i}.ssl.cert":
      setting  => "plugin.${connector}.pool.${i}.ssl.cert",
      username => $username,
      order    => $order,
      value    => "${homedir}/.mcollective.d/credentials/certs/${callerid}.pem",
    }

    mco_user::setting { "${username} plugin.${connector}.pool.${i}.ssl.key":
      setting  => "plugin.${connector}.pool.${i}.ssl.key",
      username => $username,
      order    => $order,
      value    => "${homedir}/.mcollective.d/credentials/private_keys/${callerid}.pem",
    }
  }

  $indexes = range('1', $pool_size)
  mco_user::hosts_iteration { $indexes:
  username => $username,
  middleware_password => $middleware_password,
  middleware_port => $middleware_port,
  middleware_hosts => $middleware_hosts,
  middleware_user => $middleware_user,
  middleware_ssl => $middleware_ssl,
  middleware_ssl_fallback => $middleware_ssl_fallback,
  middleware_ssl_port => $middleware_ssl_port,
  }
}
