# File::      <tt>server/redhat.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: ganglia::server::redhat
#
# Specialization class for Redhat systems
class ganglia::server::redhat inherits ganglia::server::common {

  exec { '/bin/cp -f /usr/share/ganglia/conf/default.json /var/lib/ganglia/conf/':
    unless => '/bin/test -e /var/lib/ganglia/conf/default.json',
  }

}
