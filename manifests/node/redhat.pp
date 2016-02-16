# File::      <tt>node/redhat.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: ganglia::node::redhat
#
# Specialization class for Redhat systems
class ganglia::node::redhat inherits ganglia::node::common {

    File[$ganglia::params::configfile] {
        content => template('ganglia/redhat.gmond.conf.erb'),
    }

}
