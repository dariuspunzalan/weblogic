class weblogic::default() inherits weblogic::params {

  class{'weblogic::install':} ->
  class{'weblogic::patch':} ->
  Class['weblogic::default']
}
