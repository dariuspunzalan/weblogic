class weblogic::patch() inherits weblogic::params {

  File {
    owner => "${weblogic_user}",
    group => "${weblogic_group}",
  }

  file {["${oracle_symhome}/OPatch/log", "${oracle_symhome}/OPatch/patches"]:
    ensure  => directory,
  }
  file { "OPatchit.bash":
    path      => "${$weblogic_base}/bin/OPatchit.bash",
    ensure    => 'present',
    mode      => '0550',
    content   => template("OPatchit.bash.erb"),
  }

  $wls_patches.each | $patchfile | {
    if ($patchfile =~ /^p(\d+)_(\d+)_Generic.zip/) {
      $patchid = "$1"
    }
    file {"$patchfile":
      path    => "/tmp/$patchfile",
      source  => "http://${wls_repohost}/${wls_repopath}/patches/${patchfile}",
    }
    file {"${oracle_symhome}/OPatch/patches/${patchid}":
      ensure  => directory,
      notify  => Exec["Unzip $patchfile"],
    }
    exec {"Unzip $patchfile":
      command   => "unzip /tmp/$patchfile -d $oracle_symhome/OPatch/patches",
      path      => ['/usr/bin', '/bin', '/sbin'],
      user      => "${weblogic_user}",
      group     => "${weblogic_group}",
      notify    => Exec["Execute OPatchit.bash $patchid"],
      require   => File["$patchfile"],
      refreshonly => true,
    }
    exec {"Execute OPatchit.bash $patchid":
      command   => "${$weblogic_base}/bin/OPatchit.bash $patchid",
      path      => ['/usr/bin', '/bin', '/sbin'],
      user      => "${weblogic_user}",
      group     => "${weblogic_group}",
      require   => [File["OPatchit.bash"], Exec["Unzip $patchfile"]],
      refreshonly => true,
    }
  }
}
