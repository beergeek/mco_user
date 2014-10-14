# private define
# $name will be an index into the $middleware_hostsarray + 1
define mco_user::hosts_iteration (
  $confdir,
  $homedir,
  $middleware_hosts,
  $middleware_password,
  $middleware_port,
  $middleware_ssl,
  $middleware_ssl_fallback,
  $middleware_user,
  $username,
) {

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  Mco_user::Setting {
    username => $username,
  }

  $middleware_hosts_array = flatten([$middleware_hosts])

  mco_user::setting { "plugin.activemq.pool.${name}.host":
    value => $middleware_hosts_array[$name - 1],
  }

  $fallback = $middleware_ssl_fallback ? {
    true    => 'true',
    default => 'false',
  }

  mco_user::setting { "plugin.activemq.pool.${name}.port":
    value => $middleware_port,
  }

  mco_user::setting { "plugin.activemq.pool.${name}.user":
    value => $middleware_user,
  }

  mco_user::setting { "plugin.activemq.pool.${name}.password":
    value => $middleware_password,
  }

  if $middleware_ssl {
    mco_user::setting { "plugin.activemq.pool.${name}.ssl":
      value => 'true',
    }

    mco_user::setting { "plugin.activemq.pool.${name}.ssl.fallback":
      value => $fallback,
    }

    mco_user::setting { "plugin.activemq.pool.${name}.ssl.ca":
      value => "${homedir}/.mcollective.d/credentials/certs/ca.pem",
    }

    mco_user::setting { "plugin.activemq.pool.${name}.ssl.cert":
      value => "${homedir}/.mcollective.d/credentials/certs/${callerid}.pem",
    }

    mco_user::setting { "plugin.activemq.pool.${name}.ssl.key":
      value => "${homedir}/.mcollective.d/credentials/private_keys/${callerid}.pem",
    }
  }
}
