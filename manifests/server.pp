# File::      <tt>server.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
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
    $clustername,
    $nodemin,
    $nodemax,
    $ensure = $ganglia::params::ensure
)
inherits ganglia::params
{
    info ("Configuring ganglia::server (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("ganglia::server 'ensure' parameter must be set to either 'absent' or 'present'")
    }

    case $::operatingsystem {
        'debian', 'ubuntu':         { include ::ganglia::server::debian }
        default: {
            fail("Module ${module_name} is not supported on $::{operatingsystem}")
        }
    }
}
