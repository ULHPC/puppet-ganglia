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

    service { 'ganglia-server':
        ensure  => running,
        name    => $ganglia::params::serverservicename,
        enable  => true,
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

    $headertemplatefile = '/usr/share/ganglia-webfrontend/templates/default/header.tpl'
    exec {
      "sed -i '/tabs-autorotation/d' ${headertemplatefile}":
      path    => '/usr/bin:/usr/sbin:/bin',
      onlyif  => "grep 'tabs-autorotation' ${headertemplatefile}",
      require => Package['ganglia-webfrontend'],
    }
    exec {
      "sed -i '/Views<\\/a><\\/li>/d' ${headertemplatefile}":
      path    => '/usr/bin:/usr/sbin:/bin',
      onlyif  => "grep 'Views<\\/a><\\/li>' ${headertemplatefile}",
      require => Package['ganglia-webfrontend'],
    }

    $cssfile = '/usr/share/ganglia-webfrontend/styles.css'
    exec {
      "echo '#tabs-autorotation{ visibility: hidden; }' >> ${cssfile}":
      path    => '/usr/bin:/usr/sbin:/bin',
      unless  => "grep 'tabs-autorotation' ${cssfile}",
      require => Package['ganglia-webfrontend'],
    }


}

