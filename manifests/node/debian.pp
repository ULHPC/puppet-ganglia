# File::      <tt>node/debian.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: ganglia::node::debian
#
# Specialization class for Debian systems
class ganglia::node::debian inherits ganglia::node::common {

    File[$ganglia::params::configfile] {
        content => template('ganglia/debian.gmond.conf.erb'),
    }

}
