# mco_user

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with mco_user](#setup)
    * [What mco_user affects](#what-mco_users-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mco_user](#beginning-with-mco_users)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

A module to manage MCO client user configuration.
More capability in the targeted environment than puppetlabs-mcollective.

## Module Description

Targeted to PE installations using ActiveMQ.

## Setup

### What mco_user affects

* User's .mcollective.d directory
* User's .mcollective file
* User's certificates and keys for MCollective.


### Setup Requirements

This module assumes the user exists, their home directory, and keys/certs.

### Beginning with mco_user

As a minimum the user's keys and certs must be provided, plus the ActiveMQ broker.
```puppet
  mco_user { 'peadmin':
    certificate       => '/etc/puppetlabs/puppet/ssl/certs/pe-internal-peadmin-mcollective-client.pem',
    middleware_hosts  => ['s0.puppetlabs.vm','s1.puppetlabs.vm'],
    ssl_ca_cert       => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    ssl_server_public => '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-mcollective-servers.pem',
    homedir           => '/var/lib/peadmin',
    middleware_user   => 'mcollective',
  }
```

## Usage

###Public
####mco_user: defined type to manage MCollective user

###Private
####mco_user::hosts_iteration: defined type to manage ActiveMQ entries.

## Reference

###Parameters

####mco_user

#####`certificate`
The absolute path of the local PEM file, on the node, for the CERT.
No Default.

#####`middleware_hosts`
String or an array of FQDN addresses for ActiveMQ brokers to join.
No Default.

#####`private_key`
The absolute path of the local PEM file, ont he node, for the provate key.
No Default.

#####`public_key`
The absolute path of the local PEM file, on the node, for the public key.
No Default.

#####`ssl_ca_cert`
The absolute path of the local PEM file, on the node, for the CA CERT.
No Default.

#####`ssl_server_public`
The absolute path of the local PEM file, on the node, for the public key.
No Default.

#####`base64`
Boolean value to determine if Base64 plugin is enabled.
Default is true.

#####`callerid`
The name of the caller for the client.
Default is $name.

#####`collective`
A string or array of collectives the client belongs too.
Default is 'mcollective'.

#####`core_libdir`
Core library path for MCollective.
Defaults to '/opt/puppet/libexec/mcollective'.

#####`discovery_timeout`
Timeout for discovery, in seconds.
Default is 5.

#####`group`
Group for file ownership.
Defaults to $name.

#####`homedir`
Home directory of user.
Defaults to '/home/${username}'.

#####`logfile`
Absolute path for the client log.
Defaults to 'var/lib/${username}/.mcollective.d/client.log'.

#####`loglevel`
Loglevel for client.
Defaults to 'info'.

#####`main_collective`
The main collective for the client.
Defaults to 'mcollective'.

#####`middleware_password`
Password for the ActiveMQ Pool client.
Default is 'mcollective'.

#####`middleware_port`
Port of the ActiveMQ Pool port.
Default is '61613'.

#####`middleware_ssl`
Boolean value to determine if ActiveMQ SSL is enabled.
Defaults is true.

#####`middleware_ssl_fallback`
Boolean value to determine if unverified SSL is allowed.
Default is false.

#####`middleware_user`
Name of the ActiveMQ Pool user.
Default is $name.

#####`securityprovider`
Name of the security provider.
Default is 'ssl'.

#####`site_libdir`
Absolute path of the site library directory.
Default is '/usr/local/libexec/mcollective'.

#####`username`
User name for file ownership.
Default is $name.

```puppet
  mco_user { 'peadmin':
    certificate       => '/etc/puppetlabs/puppet/ssl/certs/pe-internal-peadmin-mcollective-client.pem',
    homedir           => '/var/lib/peadmin',
    middleware_hosts  => ['s0.puppetlabs.vm','s1.puppetlabs.vm'],
    middleware_user   => 'mcollective',
    private_key       => '/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-peadmin-mcollective-client.pem',
    public_key        => '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-peadmin-mcollective-client.pem',
    ssl_ca_cert       => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    ssl_server_public => '/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-mcollective-servers.pem',
  }
```

## Limitations

Tested only on RHEL6.5

## Development


