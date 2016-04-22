define rsyslogv8::config::imfile(
  $files         = [ $title ],
  $ruleset_name  = 'RSYSLOG_DefaultRuleset',
  $rsyslog_tag   = $title,
  $facility      = 'local0',
  $severity      = 'notice',
  $readmode      = 'line',
) {
  if ! is_array($files) {
    fail('files must be an array of file full-paths')
  }
  validate_absolute_path($files)
  if ! is_string($ruleset_name) {
    fail('ruleset_name must be a string')
  }
  if ! ( is_string($facility) or is_number($facility) ) {
    fail('facility must be a string or an integer')
  }
  if ! is_string($rsyslog_tag) {
    fail('rsyslog_tag must be a string')
  }
  if ! ( is_string($severity) or is_number($severity) ) {
    fail('severity must be a string or an integer')
  }
  if ! ( is_string($readmode) or is_number($readmode) ) {
    fail('readmode must be a string or an integer')
  }
  case $facility {
    'kern', 0,
    'user', 1,
    'mail', 2,
    'daemon', 3,
    'auth', 4,
    'syslog', 5,
    'lpr', 6,
    'news', 7,
    'uucp', 8,
    'cron', 9,
    'security', 'authpriv', 10,
    'ftp', 11,
    'ntp', 12,
    'logaudit', 13,
    'logalert', 14,
    'clock', 15,
    'local0', 16,
    'local1', 17,
    'local2', 18,
    'local3', 19,
    'local4', 20,
    'local5', 21,
    'local6', 22,
    'local7', 23: {
    }

    default: {
      fail("unknown facility ${facility} supported values are any in ['kern', 0, 'user', 1, 'mail', 2, 'daemon', 3, 'auth', 4, 'syslog', 5, 'lpr', 6, 'news', 7, 'uucp', 8, 'cron', 9, 'security', 'authpriv', 10, 'ftp', 11, 'ntp', 12, 'logaudit', 13, 'logalert', 14, 'clock', 15, 'local0', 16, 'local1', 17, 'local2', 18, 'local3', 19, 'local4', 20, 'local5', 21, 'local6', 22, 'local7', 23]")
    }
  }
  case $severity {
    'emerg', 0,
    'alert', 1,
    'crit', 2,
    'error', 3,
    'warning', 4,
    'notice', 5,
    'info', 6,
    'debug', 7: {
    }

    default: {
      fail("unknown severity ${severity} supported values are any in ['emerg', 0, 'alert', 1, 'crit', 2, 'error', 3, 'warning', 4, 'notice', 5, 'info', 6, 'debug', 7]")
    }
  }
  case $readmode {
    'line', 0: {
      $_real_readmode = 0
    }
    'paragraph', 1: {
      $_real_readmode = 1
    }
    'indented', 2: {
      $_real_readmode = 2
    }

    default: {
      fail("unknown readmode ${readmode} supported values are any in ['line', 0, 'paragraph', 1, 'indented', 2]")
    }
  }

  # create config snippet using template
  ::rsyslogv8::config::snippet { "imfile-${title}":
    content  => template("${module_name}/config/imfile.erb"),
    priority => 20,
  }
}
