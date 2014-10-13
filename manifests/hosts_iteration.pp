# private define
# $name will be an index into the $middleware_hostsarray + 1
define mco_user::hosts_iteration (
  $middleware_hosts,
  $middleware_password,
  $middleware_user,
  $username,
  $middleware_ssl_port = '61613',
  $middleware_port = '61613',
  $middleware_ssl_fallback = false,
  $middleware_user = $username,
  $middleware_ssl = true,
  $confdir = '/etc/puppetlabs/mcollective',
) {
  Mco_user::Setting {
    username => $username,
  } 
 
  $middleware_hosts_array = flatten([$middleware_hosts])
  
  mco_user::setting { "plugin.activemq.pool.${name}.host":
    value => $middleware_hosts_array[$name - 1],
  }

  $port = $middleware_ssl ? {
    true    => $middleware_ssl_port,
    default => $middleware_port,
  }

  $fallback = $middleware_ssl_fallback ? {
    true    => 1,
    default => 0,
  }

  mco_user::setting { "plugin.activemq.pool.${name}.port":
    value => $port,
  }

  mco_user::setting { "plugin.activemq.pool.${name}.user":
    value => $middleware_user,
  }

  mco_user::setting { "plugin.activemq.pool.${name}.password":
    value => $middleware_password,
  }

  if $middleware_ssl {
    mco_user::setting { "plugin.activemq.pool.${name}.ssl":
      value => 1,
    }

    mco_user::setting { "plugin.activemq.pool.${name}.ssl.ca":
      value => "${confdir}/ca.pem",
    }

    mco_user::setting { "plugin.activemq.pool.${name}.ssl.fallback":
      value => $fallback,
    }
  }
}
