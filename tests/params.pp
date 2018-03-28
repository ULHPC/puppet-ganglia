# File::      <tt>params.pp</tt>
# Author::    S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team (hpc-sysadmins@uni.lu)
# Copyright:: Copyright (c) 2016 S. Varrette, H. Cartiaux, V. Plugaru, S. Diehl aka. UL HPC Management Team
# License::   Gpl-3.0
#
# ------------------------------------------------------------------------------
# You need the 'future' parser to be able to execute this manifest (that's
# required for the each loop below).
#
# Thus execute this manifest in your vagrant box as follows:
#
#      sudo puppet apply -t --parser future /vagrant/tests/params.pp
#
#

include '::ganglia::params'

$names = ['ensure', 'packagename', 'serverpackagename', 'servicename', 'serverservicename', 'gmond_status_command', 'ibgit', 'ibtarget', 'ibmakedep', 'configfile', 'serverconfigfile', 'webconfigfile', 'apacheconfigfile', 'apachetarget', 'configfile_mode', 'configfile_owner', 'configfile_group']

notice("ganglia::params::ensure = ${ganglia::params::ensure}")
notice("ganglia::params::packagename = ${ganglia::params::packagename}")
notice("ganglia::params::serverpackagename = ${ganglia::params::serverpackagename}")
notice("ganglia::params::servicename = ${ganglia::params::servicename}")
notice("ganglia::params::serverservicename = ${ganglia::params::serverservicename}")
notice("ganglia::params::gmond_status_command = ${ganglia::params::gmond_status_command}")
notice("ganglia::params::ibgit = ${ganglia::params::ibgit}")
notice("ganglia::params::ibtarget = ${ganglia::params::ibtarget}")
notice("ganglia::params::ibmakedep = ${ganglia::params::ibmakedep}")
notice("ganglia::params::configfile = ${ganglia::params::configfile}")
notice("ganglia::params::serverconfigfile = ${ganglia::params::serverconfigfile}")
notice("ganglia::params::webconfigfile = ${ganglia::params::webconfigfile}")
notice("ganglia::params::apacheconfigfile = ${ganglia::params::apacheconfigfile}")
notice("ganglia::params::apachetarget = ${ganglia::params::apachetarget}")
notice("ganglia::params::configfile_mode = ${ganglia::params::configfile_mode}")
notice("ganglia::params::configfile_owner = ${ganglia::params::configfile_owner}")
notice("ganglia::params::configfile_group = ${ganglia::params::configfile_group}")

#each($names) |$v| {
#    $var = "ganglia::params::${v}"
#    notice("${var} = ", inline_template('<%= scope.lookupvar(@var) %>'))
#}
