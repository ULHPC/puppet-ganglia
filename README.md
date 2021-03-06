-*- mode: markdown; mode: visual-line;  -*-

# Ganglia Puppet Module 

[![Puppet Forge](http://img.shields.io/puppetforge/v/ULHPC/ganglia.svg)](https://forge.puppetlabs.com/ULHPC/ganglia)
[![License](http://img.shields.io/:license-GPL3.0-blue.svg)](LICENSE)
![Supported Platforms](http://img.shields.io/badge/platform-debian|centos-lightgrey.svg)
[![Documentation Status](https://readthedocs.org/projects/ulhpc-puppet-ganglia/badge/?version=latest)](https://readthedocs.org/projects/ulhpc-puppet-ganglia/?badge=latest)

Configure and manage Ganglia

      Copyright (c) 2018 UL HPC Team <hpc-sysadmins@uni.lu>
      

| [Project Page](https://github.com/ULHPC/puppet-ganglia) | [Sources](https://github.com/ULHPC/puppet-ganglia) | [Documentation](https://ulhpc-puppet-ganglia.readthedocs.org/en/latest/) | [Issues](https://github.com/ULHPC/puppet-ganglia/issues) |

## Synopsis

Configure and manage Ganglia.

This module implements the following elements: 

* __Puppet classes__:
    - `ganglia::node` 
    - `ganglia::node::common` 
    - `ganglia::node::debian` 
    - `ganglia::node::redhat` 
    - `ganglia::params` 
    - `ganglia::server` 
    - `ganglia::server::common` 
    - `ganglia::server::debian` 
    - `ganglia::server::redhat` 

* __Puppet definitions__: 

All these components are configured through a set of variables you will find in
[`manifests/params.pp`](manifests/params.pp). 

_Note_: the various operations that can be conducted from this repository are piloted from a [`Rakefile`](https://github.com/ruby/rake) and assumes you have a running [Ruby](https://www.ruby-lang.org/en/) installation.
See `docs/contributing.md` for more details on the steps you shall follow to have this `Rakefile` working properly. 

## Dependencies

See [`metadata.json`](metadata.json). In particular, this module depends on 

* [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
* [puppetlabs/vcsrepo](https://forge.puppetlabs.com/puppetlabs/vcsrepo)
* [ULHPC/sudo](https://forge.puppetlabs.com/ULHPC/sudo)

## Overview and Usage

### Class `ganglia`

This is the main class defined in this module.
It accepts the following parameters: 

* `$ensure`: default to 'present', can be 'absent'

Use it as follows:

     include ' ganglia'

See also [`tests/init.pp`](tests/init.pp)

### Class `ganglia::node`

See [`tests/node.pp`](tests/node.pp)
### Class `ganglia::node::debian`

See [`tests/node/debian.pp`](tests/node/debian.pp)
### Class `ganglia::node::redhat`

See [`tests/node/redhat.pp`](tests/node/redhat.pp)
### Class `ganglia::server`

See [`tests/server.pp`](tests/server.pp)
### Class `ganglia::server::debian`

See [`tests/server/debian.pp`](tests/server/debian.pp)
### Class `ganglia::server::redhat`

See [`tests/server/redhat.pp`](tests/server/redhat.pp)


## Librarian-Puppet / R10K Setup

You can of course configure the ganglia module in your `Puppetfile` to make it available with [Librarian puppet](http://librarian-puppet.com/) or
[r10k](https://github.com/adrienthebo/r10k) by adding the following entry:

     # Modules from the Puppet Forge
     mod "ULHPC/ganglia"

or, if you prefer to work on the git version: 

     mod "ULHPC/ganglia", 
         :git => 'https://github.com/ULHPC/puppet-ganglia',
         :ref => 'production' 

## Issues / Feature request

You can submit bug / issues / feature request using the [ULHPC/ganglia Puppet Module Tracker](https://github.com/ULHPC/puppet-ganglia/issues). 

## Developments / Contributing to the code 

If you want to contribute to the code, you shall be aware of the way this module is organized. 
These elements are detailed on [`docs/contributing.md`](contributing/index.md).

You are more than welcome to contribute to its development by [sending a pull request](https://help.github.com/articles/using-pull-requests). 

## Puppet modules tests within a Vagrant box

The best way to test this module in a non-intrusive way is to rely on [Vagrant](http://www.vagrantup.com/).
The `Vagrantfile` at the root of the repository pilot the provisioning various vagrant boxes available on [Vagrant cloud](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=virtualbox&q=svarrette) you can use to test this module.

See [`docs/vagrant.md`](vagrant.md) for more details. 

## Online Documentation

[Read the Docs](https://readthedocs.org/) aka RTFD hosts documentation for the open source community and the [ULHPC/ganglia](https://github.com/ULHPC/puppet-ganglia) puppet module has its documentation (see the `docs/` directly) hosted on [readthedocs](http://ulhpc-puppet-ganglia.rtfd.org).

See [`docs/rtfd.md`](rtfd.md) for more details.

## Licence

This project and the sources proposed within this repository are released under the terms of the [GPL-3.0](LICENCE) licence.


[![Licence](https://www.gnu.org/graphics/gplv3-88x31.png)](LICENSE)
