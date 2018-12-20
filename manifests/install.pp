class weblogic::install() inherits weblogic::params
{

  if ! defined(Group[$weblogic_group]) {
    group{"$weblogic_group":
      ensure  => present,
      gid     => "${weblogic_gid}",
    }
  }

  if ! defined(User[$weblogic_user]) {
    user{$weblogic_user:
      ensure  => present,
      uid     => "${weblogic_uid}",
      gid     => "${weblogic_gid}",
      comment => "${weblogic_comment}",
      shell   => "${weblogic_shell}",
      home    => "${weblogic_home}",
      managehome  => 'true',
    }
  }

  File{
    owner => "${weblogic_user}",
    group => "${weblogic_group}",
  }

  file {["$weblogic_base",
        "$weblogic_base/src",
        "$weblogic_base/etc",
        "$weblogic_base/bin",
        "${oracle_base}/product",
        "${oracle_base}/product/wls-${weblogic_version}" ]:
    ensure    => directory,
    mode      => '0755',
  }

  file {$oracle_symhome:
    path      => "$oracle_symhome",
    ensure    => link,
    target    => "${wls_fullhome}",
  }

  file {"weblogic installer $wls_distro":
    path      => "$weblogic_base/src/$wls_distro",
    ensure    => present,
    source    => "http://${wls_repohost}/${wls_repopath}/${wls_distro}",
    mode      => '0770',
  }

  file {"wls_install.bash":
    path      => "${weblogic_base}/bin/wls_install.bash",
    ensure    => "present",
    mode      => '0770',
    content   => template("wls_install.bash.erb"),
  }

  file {"response_file":
    path      => "${weblogic_base}/src/wls-silent.install.rsp",
    ensure    => 'present',
    mode      => '0550',
    content   => template("wls-silent.install.rsp.erb"),
  }

  file {"oraInst.loc":
    path      => "${weblogic_base}/etc/oraInst.loc",
    ensure    => 'present',
    mode      => '0550',
    content   => template("oraInst.loc.erb"),
  }

  exec {"Execute installer":
    command   => "${weblogic_base}/bin/wls_install.bash",
    path      => ['/usr/bin', '/bin', '/sbin'],
    user      => "${weblogic_user}",
    group     => "${weblogic_group}",
    require   => [File['wls_install.bash', "response_file", "oraInst.loc"], ],
    creates   => "${wls_fullhome}/wlserver/server/bin/startNodeManager.sh",
  }
}
