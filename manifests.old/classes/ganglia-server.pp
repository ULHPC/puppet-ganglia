# File::      <tt>ganglia-node.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: ganglia::server
#
# Configure and manage ganglia::server
#
# == Parameters:
#
# $ensure:: *Default*: 'present'. Ensure the presence (or absence) of ganglia::server
#
# == Actions:
#
# Install and configure ganglia::server
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     import ganglia::server
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'ganglia::server':
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
class ganglia::server(
    $ensure = $ganglia::params::ensure,
    $clustername,
    $nodemin,
    $nodemax
)
inherits ganglia::params
{
    info ("Configuring ganglia::server (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("ganglia::server 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        debian, ubuntu:         { include ganglia::server::debian }
        default: {
            fail("Module $module_name is not supported on $operatingsystem")
        }
    }
}

# ------------------------------------------------------------------------------
# = Class: ganglia::server::common
#
# Base class to be inherited by the other ganglia::server classes
#
# Note: respect the Naming standard provided here[http://projects.puppetlabs.com/projects/puppet/wiki/Module_Standards]
class ganglia::server::common {

    # Load the variables used in this module. Check the ganglia-params.pp file
    require ganglia::params

    package { 'ganglia-webfrontend':
        ensure  => "${ganglia::server::ensure}",
        name    => "${ganglia::params::serverpackagename}",
    }

    # Configuration file
    file { "${ganglia::params::serverconfigfile}":
        ensure  => "${ganglia::server::ensure}",
        path    => "${ganglia::params::serverconfigfile}",
        owner   => "${ganglia::params::configfile_owner}",
        group   => "${ganglia::params::configfile_group}",
        mode    => "${ganglia::params::configfile_mode}",
        content => template("ganglia/gmetad.conf.erb"),
        notify  => Service['ganglia-server'],
        require => Package['ganglia-webfrontend'],
    }

    file { "${ganglia::params::webconfigfile}":
        ensure  => "${ganglia::server::ensure}",
        path    => "${ganglia::params::webconfigfile}",
        owner   => "${ganglia::params::configfile_owner}",
        group   => "${ganglia::params::configfile_group}",
        mode    => "${ganglia::params::configfile_mode}",
        content => template("ganglia/conf_default.php.erb"),
        require => Package['ganglia-webfrontend'],
    }

    service { 'ganglia-server':
        name       => "${ganglia::params::serverservicename}",
        enable     => true,
        ensure     => running,
        require    => [
                       Package['ganglia-webfrontend'],
                       File["${ganglia::params::serverconfigfile}"]
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


# ------------------------------------------------------------------------------
# = Class: ganglia::server::debian
#
# Specialization class for Debian systems
class ganglia::server::debian inherits ganglia::server::common { }

