# File::      <tt>node/redhat.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# = Class: ganglia::server::debian
#
# Specialization class for Debian systems
class ganglia::server::debian inherits ganglia::server::common {

  # Ensure package lists are updated before attempting package installation.
  exec { 'apt-update':
    command => '/usr/bin/apt-get update'
  }
  Exec['apt-update'] -> Package <| |>
}
