class weblogic::users() inherits weblogic::params {
  if defined(Group[$weblogic_group]) {
    User<| tag == 'weblogic::users' and title != "weblogic_user" |> {
      groups +> ["${weblogic_group}"],
    }
  }


}
