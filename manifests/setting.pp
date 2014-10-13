define mco_user::setting(
  $username,
  $setting = $name,
  $value,
  $order = '70'
) {
  mcollective::setting { "mcollective::user::setting ${title}":
    setting => $setting,
    value   => $value,
    target  => "mcollective::user ${username}",
    order   => $order,
  }
}
