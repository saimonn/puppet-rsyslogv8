class rsyslogv8::service {
  service { $::rsyslogv8::service_name:
    ensure  => 'running',
    enable  => true,
    require => Class['rsyslogv8::config'],
  }
}
