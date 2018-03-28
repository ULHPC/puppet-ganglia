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
    $clustername,
    $owner,
    $latlong,
    $url,
    $location,
    $ensure        = $ganglia::params::ensure,
    $infiniband    = 'no'
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
        'debian', 'ubuntu':         { include ::ganglia::node::debian }
        'redhat', 'fedora', 'centos': { include ::ganglia::node::redhat }
        default: {
            fail("Module ${module_name} is not supported on $::{operatingsystem}")
        }
    }
}

