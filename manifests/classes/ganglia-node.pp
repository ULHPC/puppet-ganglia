# File::      <tt>ganglia-node.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: ganglia::node
#
# Configure and manage ganglia::node
#
# == Parameters:
#
# $ensure:: *Default*: 'present'. Ensure the presence (or absence) of ganglia::node
#
# == Actions:
#
# Install and configure ganglia::node
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     import ganglia::node
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'ganglia::node':
#             ensure => 'present'
#         }
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
#
# [Remember: No empty lines between comments and class definition]
#
class ganglia::node(
    $ensure = $ganglia::params::ensure,
    $clustername,
    $owner,
    $latlong,
    $url,
    $location
)
inherits ganglia::params
{
    info ("Configuring ganglia::node (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("ganglia::node 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include ganglia::node::debian }
        redhat, fedora, centos: { include ganglia::node::redhat }
        default: {
            fail("Module $module_name is not supported on $operatingsystem")
        }
    }
}

# ------------------------------------------------------------------------------
# = Class: ganglia::node::common
#
# Base class to be inherited by the other ganglia::node classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class ganglia::node::common {

    # Load the variables used in this module. Check the ganglia-params.pp file
    require ganglia::params

    package { 'ganglia-monitor':
        ensure  => "${ganglia::node::ensure}",
        name    => "${ganglia::params::packagename}",
    }

    # Configuration file
    file { "${ganglia::params::configfile}":
        ensure  => "${ganglia::node::ensure}",
        path    => "${ganglia::params::configfile}",
        owner   => "${ganglia::params::configfile_owner}",
        group   => "${ganglia::params::configfile_group}",
        mode    => "${ganglia::params::configfile_mode}",
        notify  => Service['ganglia-node'],
        require => Package['ganglia-monitor'],
    }

    service { 'ganglia-node':
        name       => "${ganglia::params::servicename}",
        enable     => true,
        ensure     => running,
        require    => [
                       Package['ganglia-monitor'],
                       File["${ganglia::params::configfile}"]
                       ],
    }

}


# ------------------------------------------------------------------------------
# = Class: ganglia::node::debian
#
# Specialization class for Debian systems
class ganglia::node::debian inherits ganglia::node::common {

    File["${ganglia::params::configfile}"] {
        content => template("ganglia/debian.gmond.conf.erb"),
    }

}

# ------------------------------------------------------------------------------
# = Class: ganglia::node::redhat
#
# Specialization class for Redhat systems
class ganglia::node::redhat inherits ganglia::node::common {

    File["${ganglia::params::configfile}"] {
        content => template("ganglia/redhat.gmond.conf.erb"),
    }

}



