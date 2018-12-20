class weblogic::params() {

  $weblogic_user          = hiera('weblogic::data::weblogic_user', 'weblogic')
  $weblogic_group         = hiera('weblogic::data::weblogic_group', 'weblogic')
  $weblogic_comment       = hiera('weblogic::data::weblogic_comment', 'Weblogic Admin')
  $weblogic_shell         = hiera('weblogic::data::weblogic_shell', '/bin/bash')
  $weblogic_uid           = hiera('weblogic::data::weblogic_uid', '20000')
  $weblogic_gid           = hiera('weblogic::data::weblogic_gid', '20000')
  $weblogic_home          = hiera('weblogic::data::weblogic_home', '/home/weblogic')
  $wls_repohost           = $facts['razor_metadata_repo_server']
  $weblogic_base          = hiera('weblogic::data::weblogic_base', '/apps/weblogicinstall')
  $wls_distro             = hiera('weblogic::data::wls_distro', 'fmw_12.1.3.0.0_wls.jar')
  $wls_repopath           = hiera('weblogic::data::wls_repopath', 'files/repo')
  $java_home              = hiera('weblogic::data::java_home', '/usr/java/latest')
  $oracle_base            = hiera('weblogic::data::oracle_base', '/apps')
  $oracle_symhome         = hiera('weblogic::data::oracle_home', "${oracle_base}/product/wls")
  $install_java_version	  = hiera('weblogic::data::install_java_version', 'jdk-1.7.0_80')

  if ($wls_distro =~ /^fmw_(\d+.\d+.\d+).(\d+.\d+)_wls.jar/) {
    $weblogic_version = "$1"
  }
  $wls_fullhome           = "${oracle_base}/product/wls-${weblogic_version}"
  $wls_patches            = lookup("${role}::wls_patches", Array[String], 'unique', [])
  if ($install_java_version =~ /^j.*.(\d+).(\d_.*)/) {
    $java_version = $1
  }
  file{"/tmp/java_${java_version}":
    ensure => 'directory',
  }

}
