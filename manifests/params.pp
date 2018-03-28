# File::      <tt>params.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
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
    $ensure =  'present'

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
      /(?i-mx:centos|fedora|redhat)/ => 'ganglia-web',
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

    # ubuntu 12.10 and below didn't have a status command in the init script
    if ! (($::operatingsystem == 'Ubuntu' and versioncmp($::lsbmajdistrelease, '12') > 0) or
          ($::operatingsystem == 'Debian' and $::lsbmajdistrelease != '7')) {
        $gmond_status_command  = 'pgrep -u ganglia -f /usr/sbin/gmond'
    }

    $ibgit = 'https://github.com/ULHPC/ganglia_infiniband_module'
    $ibtarget = '/root/ganglia_infiniband_module'
    $ibmakedep = $::operatingsystem ? {
        /(?i-mx:ubuntu|debian)/        => ['gcc', 'libapr1-dev', 'libconfuse-dev', 'libexpat1-dev', 'libganglia1-dev'],
        default                        => ['gcc', 'apr-devel', 'expat-devel', 'libconfuse-devel', 'ganglia-devel'],
    } # + make, which is already defined in the generic module

    $configfile = $::operatingsystem ? {
        default => '/etc/ganglia/gmond.conf',
    }
    $serverconfigfile = $::operatingsystem ? {
        default => '/etc/ganglia/gmetad.conf',
    }
    $webconfigfile = $::operatingsystem ? {
      /(?i-mx:ubuntu|debian)/        => '/etc/ganglia-webfrontend/conf.php',
      /(?i-mx:centos|fedora|redhat)/ => '/etc/ganglia/conf.php',
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

    $headertemplatefile = $::operatingsystem ? {
      /(?i-mx:ubuntu|debian)/        => '/usr/share/ganglia-webfrontend/templates/default/header.tpl',
      /(?i-mx:centos|fedora|redhat)/ => '/usr/share/ganglia/templates/default/header.tpl',
      default => '/usr/share/ganglia-webfrontend/templates/default/header.tpl',
    }
    $cssfile = $::operatingsystem ? {
      /(?i-mx:ubuntu|debian)/        => '/usr/share/ganglia-webfrontend/styles.css',
      /(?i-mx:centos|fedora|redhat)/ => '/usr/share/ganglia/styles.css',
      default => '/usr/share/ganglia-webfrontend/styles.css',
    }

}

