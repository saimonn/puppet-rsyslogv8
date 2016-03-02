class rsyslogv8::config {
  file { $rsyslogv8::rsyslog_d:
    ensure  => directory,
    owner   => 'root',
    group   => $rsyslogv8::run_group,
    purge   => $rsyslogv8::purge_rsyslog_d,
    recurse => true,
    force   => true,
    require => Class['rsyslogv8::install'],
  }

  file { $rsyslogv8::rsyslog_conf:
    ensure  => file,
    owner   => 'root',
    group   => $rsyslogv8::run_group,
    content => template("${module_name}/rsyslog.conf.erb"),
    require => Class['rsyslogv8::install'],
    notify  => Class['rsyslogv8::service'],
  }

  file { $rsyslogv8::spool_dir:
    ensure  => directory,
    owner   => $rsyslogv8::run_user,
    group   => $rsyslogv8::run_group,
    mode    => '0700',
    seltype => 'syslogd_var_lib_t',
    require => Class['rsyslogv8::install'],
    notify  => Class['rsyslogv8::service'],
  }

}
