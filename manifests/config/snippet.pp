define rsyslogv8::config::snippet(
  $content,
  $priority = 50,
) {
  file { "${::rsyslogv8::rsyslog_d}/${priority}-${title}.conf":
    owner   => 'root',
    group   => $::rsyslogv8::run_user,
    content => $content,
    require => Class['rsyslogv8::config'],
    before  => Class['rsyslogv8::service'],
    notify  => Class['rsyslogv8::service'],
  }
}
