# File::      <tt>ganglia-params.pp</tt>
# Author::    Hyacinthe Cartiaux (hyacinthe.cartiaux@uni.lu)
# Copyright:: Copyright (c) 2013 Hyacinthe Cartiaux
# License::   GPLv3
#
# ------------------------------------------------------------------------------
# = Class: ganglia::params
#
# In this class are defined as variables values that are used in other
# ganglia classes.
# This class should be included, where necessary, and eventually be enhanced
# with support for more OS
#
# == Warnings
#
# /!\ Always respect the style guide available
# here[http://docs.puppetlabs.com/guides/style_guide]
#
# The usage of a dedicated param classe is advised to better deal with
# parametrized classes, see
# http://docs.puppetlabs.com/guides/parameterized_classes.html
#
# [Remember: No empty lines between comments and class definition]
#
class ganglia::params {

    ######## DEFAULTS FOR VARIABLES USERS CAN SET ##########################
    # (Here are set the defaults, provide your custom variables externally)
    # (The default used is in the line with '')
    ###########################################

    # ensure the presence (or absence) of ganglia
    $ensure = $ganglia_ensure ? {
        ''      => 'present',
        default => "${ganglia_ensure}"
    }

    #### MODULE INTERNAL VARIABLES  #########
    # (Modify to adapt to unsupported OSes)
    #######################################
    # ganglia packages
    $packagename = $::operatingsystem ? {
         /(?i-mx:ubuntu|debian)/        => 'ganglia-monitor',
         /(?i-mx:centos|fedora|redhat)/ => 'ganglia-gmond',
         default => 'ganglia-monitor'
    }
    $serverpackagename = $::operatingsystem ? {
         /(?i-mx:ubuntu|debian)/        => 'ganglia-webfrontend',
         default => 'ganglia-webfrontend'
    }

    # ganglia associated services
    $servicename = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/        => 'ganglia-monitor',
        /(?i-mx:centos|fedora|redhat)/ => 'gmond',
        default                        => 'ganglia-monitor'
    }
    $serverservicename = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/        => 'gmetad',
        default                        => 'gmetad'
    }

    $ibgit = 'https://github.com/ULHPC/ganglia_infiniband_module'
    $ibtarget = '/root/ganglia_infiniband_module'
    $ibmakedep = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/        => ['gcc', 'libapr1-dev', 'libconfuse-dev',
                                           'libexpat1-dev', 'libganglia1-dev'],
        default                        => ['gcc', 'apr-devel', 'expat-devel',
                                           'libconfuse-devel', 'ganglia-devel'],
    } # + make, which is already defined in the generic module

    $configfile = $::operatingsystem ? {
        default => '/etc/ganglia/gmond.conf',
    }
    $serverconfigfile = $::operatingsystem ? {
        default => '/etc/ganglia/gmetad.conf',
    }
    $webconfigfile = $::operatingsystem ? {
        default => '/etc/ganglia-webfrontend/conf.php',
    }
    $apacheconfigfile = $::operatingsystem ? {
        default => '/etc/ganglia-webfrontend/apache.conf',
    }
    $apachetarget = $::operatingsystem ? {
        default => '/etc/apache2/conf.d',
    }
    $configfile_mode = $::operatingsystem ? {
        default => '0644',
    }
    $configfile_owner = $::operatingsystem ? {
        default => 'root',
    }
    $configfile_group = $::operatingsystem ? {
        default => 'root',
    }


}

