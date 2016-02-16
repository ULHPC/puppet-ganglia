# File::      <tt>init.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: ganglia
#
# Configure and manage Ganglia
#
# == Parameters:
#
# $ensure:: *Default*: 'present'. Ensure the presence (or absence) of ganglia
#
# == Actions:
#
# Install and configure ganglia
#
# == Requires:
#
# n/a
#
# == Sample Usage:
#
#     include 'ganglia'
#
# You can then specialize the various aspects of the configuration,
# for instance:
#
#         class { 'ganglia':
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
class ganglia(
    $ensure = $ganglia::params::ensure
)
inherits ganglia::params
{
    info ("Configuring ganglia (with ensure = ${ensure})")

    if ! ($ensure in [ 'present', 'absent' ]) {
        fail("ganglia 'ensure' parameter must be set to either 'absent' or 'present'")
    }

}
