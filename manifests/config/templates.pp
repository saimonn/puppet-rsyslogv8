# Define to manage rsyslog templates.
define rsyslogv8::config::templates (
  $templates,
) {
  if ! is_array($templates) {
    fail('templates parameter must be an array')
  }

  ::rsyslogv8::config::snippet { "templates-${title}":
    content  => template("${module_name}/config/templates.erb"),
    priority => '00',
  }
}
