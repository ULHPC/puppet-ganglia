# File::      <tt>server/common.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: ganglia::common
#
# Base class to be inherited by the other ganglia::server classes, containing the common code.
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class ganglia::server::common {

    # Load the variables used in this module. Check the ganglia-params.pp file
    require ::ganglia::params

    package { 'ganglia-webfrontend':
        ensure => $ganglia::server::ensure,
        name   => $ganglia::params::serverpackagename,
    }

    # Configuration file
    file { $ganglia::params::serverconfigfile:
        ensure  => $ganglia::server::ensure,
        path    => $ganglia::params::serverconfigfile,
        owner   => $ganglia::params::configfile_owner,
        group   => $ganglia::params::configfile_group,
        mode    => $ganglia::params::configfile_mode,
        content => template('ganglia/gmetad.conf.erb'),
        notify  => Service['ganglia-server'],
        require => Package['ganglia-webfrontend'],
    }

    file { $ganglia::params::webconfigfile:
        ensure  => $ganglia::server::ensure,
        path    => $ganglia::params::webconfigfile,
        owner   => $ganglia::params::configfile_owner,
        group   => $ganglia::params::configfile_group,
        mode    => $ganglia::params::configfile_mode,
        content => template('ganglia/conf_default.php.erb'),
        require => Package['ganglia-webfrontend'],
    }

    if ($ganglia::server::ensure == 'present') {
      $servicestatus = 'running'
      $serviceenable = true
    } else {
      $servicestatus = 'stopped'
      $serviceenable = false
    }
    service { 'ganglia-server':
        ensure  => $servicestatus,
        enable  => $serviceenable,
        name    => $ganglia::params::serverservicename,
        require => [
          Package['ganglia-webfrontend'],
          File[$ganglia::params::serverconfigfile]
        ],
    }

#   file { "${ganglia::params::apacheconfigfile}":
#       ensure => 'link',
#       target => "${apachetarget}/ganglia.conf",
#   }

    # Disable unwanted features

    if ($ganglia::server::ensure == 'present') {
        exec {
          "sed -i '/tabs-autorotation/d' ${ganglia::params::headertemplatefile}":
          path    => '/usr/bin:/usr/sbin:/bin',
          onlyif  => "grep 'tabs-autorotation' ${ganglia::params::headertemplatefile}",
          require => Package['ganglia-webfrontend'],
        }
        exec {
          "sed -i '/Views<\\/a><\\/li>/d' ${ganglia::params::headertemplatefile}":
          path    => '/usr/bin:/usr/sbin:/bin',
          onlyif  => "grep 'Views<\\/a><\\/li>' ${ganglia::params::headertemplatefile}",
          require => Package['ganglia-webfrontend'],
        }

        exec {
          "echo '#tabs-autorotation{ visibility: hidden; }' >> ${ganglia::params::cssfile}":
          path    => '/usr/bin:/usr/sbin:/bin',
          unless  => "grep 'tabs-autorotation' ${ganglia::params::cssfile}",
          require => Package['ganglia-webfrontend'],
        }
    }

}

