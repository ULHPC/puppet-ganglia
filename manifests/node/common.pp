# File::      <tt>node/common.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: ganglia::node::common
#
# Base class to be inherited by the other ganglia::node classes, containing the common code.
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class ganglia::node::common {

    # Load the variables used in this module. Check the ganglia/params.pp file
    require ::ganglia::params

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
    if ($ganglia::node::ensure == 'present') {
      $servicestatus = 'running'
      $serviceenable = true
    } else {
      $servicestatus = 'stopped'
      $serviceenable = false
    }
    service { 'ganglia-node':
        ensure    => $servicestatus,
        enable    => $serviceenable,
        name      => $ganglia::params::servicename,
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
        vcsrepo { 'git-clone-infiniband':
            ensure   => $ganglia::node::ensure,
            provider => git,
            path     => $ganglia::params::ibtarget,
            source   => $ganglia::params::ibgit,
        }

        package { $ganglia::params::ibmakedep:
            ensure => $ganglia::node::ensure,
            before => Vcsrepo['git-clone-infiniband'],
        }
        exec { 'compile':
            path    => '/sbin:/usr/bin:/usr/sbin:/bin',
            command => "make -C ${ganglia::params::ibtarget} ;",
            unless  => "test -f ${ganglia::params::ibtarget}/modInfiniband.so",
            require => Vcsrepo['git-clone-infiniband'],
            notify  => Service['ganglia-node'],
            onlyif  => "test -d ${ganglia::params::ibtarget}",
        }

        include ::sudo
        sudo::directive {'ganglia':
            ensure  => $ganglia::node::ensure,
            content => "ganglia ALL=(ALL) NOPASSWD: /usr/sbin/perfquery -R\n",
        }

    }
}

