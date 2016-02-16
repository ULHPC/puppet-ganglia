# File::      <tt>node.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
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
    $infiniband = 'no',
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

    if ! ($infiniband in [ 'yes', 'no' ]) {
        fail("ganglia::node 'infiniband' parameter must be set to either 'yes' or 'no'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include ganglia::node::debian }
        redhat, fedora, centos: { include ganglia::node::redhat }
        default: {
            fail("Module ${module_name} is not supported on $::{operatingsystem}")
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
        ensure => $ganglia::node::ensure,
        name   => $ganglia::params::packagename,
    }

    # Configuration file
    file { $ganglia::params::configfile:
        ensure  => $ganglia::node::ensure,
        path    => $ganglia::params::configfile,
        owner   => $ganglia::params::configfile_owner,
        group   => $ganglia::params::configfile_group,
        mode    => $ganglia::params::configfile_mode,
        notify  => Service['ganglia-node'],
        require => Package['ganglia-monitor'],
    }

    if ($ganglia::params::gmond_status_command) {
      $hasstatus = false
    } else {
      $hasstatus = true
    }
    service { 'ganglia-node':
        ensure    => running,
        name      => $ganglia::params::servicename,
        enable    => true,
        hasstatus => $hasstatus,
        status    => $ganglia::params::gmond_status_command,
        require   => [
          Package['ganglia-monitor'],
          File[$ganglia::params::configfile]
        ],
    }

    if ($ganglia::node::infiniband == 'yes')
    {
        # git clone
        git::clone { 'git-clone-infiniband':
            ensure => $ganglia::node::ensure,
            path   => $ganglia::params::ibtarget,
            source => $ganglia::params::ibgit,
        }

        package { $ganglia::params::ibmakedep:
            ensure => $ganglia::node::ensure,
            before => Git::Clone['git-clone-infiniband']
        }
        exec { 'compile':
            path    => '/sbin:/usr/bin:/usr/sbin:/bin',
            command => "make -C ${ganglia::params::ibtarget} ;",
            unless  => "test -f ${ganglia::params::ibtarget}/modInfiniband.so",
            require => Git::Clone['git-clone-infiniband'],
            notify  => Service['ganglia-node']
        }

    }
}


# ------------------------------------------------------------------------------
# = Class: ganglia::node::debian
#
# Specialization class for Debian systems
class ganglia::node::debian inherits ganglia::node::common {

    File[$ganglia::params::configfile] {
        content => template('ganglia/debian.gmond.conf.erb'),
    }

}

# ------------------------------------------------------------------------------
# = Class: ganglia::node::redhat
#
# Specialization class for Redhat systems
class ganglia::node::redhat inherits ganglia::node::common {

    File[$ganglia::params::configfile] {
        content => template('ganglia/redhat.gmond.conf.erb'),
    }

}



