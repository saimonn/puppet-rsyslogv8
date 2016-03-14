class rsyslogv8::config::receive_templates (
  $base_dir = '/srv/log',
) {
  rsyslogv8::config::snippet { 'receive-templates':
    priority => '00',
    content  => template("${module_name}/config/receive-templates.erb"),
  }
}
