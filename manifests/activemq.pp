define mco_user::activemq (
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
) {

  Mco_user::Setting {
    username => $username,
  }

  $i = regsubst($title, "^${username}_", '')

  if $middleware_ssl {
    mco_user::setting { "${username} plugin.${connector}.pool.${i}.ssl.ca":
      setting  => "plugin.${connector}.pool.${i}.ssl.ca",
      order    => $order,
      value    => "${homedir}/.mcollective.d/credentials/certs/ca.pem",
    }

    mco_user::setting { "${username} plugin.${connector}.pool.${i}.ssl.cert":
      setting  => "plugin.${connector}.pool.${i}.ssl.cert",
      order    => $order,
      value    => "${homedir}/.mcollective.d/credentials/certs/${callerid}.pem",
    }

    mco_user::setting { "${username} plugin.${connector}.pool.${i}.ssl.key":
      setting  => "plugin.${connector}.pool.${i}.ssl.key",
      order    => $order,
      value    => "${homedir}/.mcollective.d/credentials/private_keys/${callerid}.pem",
    }
  }

  $indexes = range('1', $pool_size)
  mco_user::hosts_iteration { $indexes:
    confdir                 => $confdir,
    middleware_hosts        => $middleware_hosts,
    middleware_password     => $middleware_password,
    middleware_port         => $middleware_port,
    middleware_ssl          => $middleware_ssl,
    middleware_ssl_fallback => $middleware_ssl_fallback,
    middleware_user         => $middleware_user,
    username                => $username,
  }
}
