define mco_user::setting(
  $username,
  $setting = $name,
  $value,
  $order = '70'
) {
  datacat_fragment { "mcollective::user::setting ${title}":
    data    => hash([ $setting, $value ]),
    target  => "mcollective::user ${username}",
    order   => $order,
  }
}
