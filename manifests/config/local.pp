class rsyslogv8::config::local(
  $template_name = "${module_name}/config/local-${::osfamily}.erb",
) {
  rsyslogv8::config::snippet { 'local':
    priority => '00',
    content  => template($template_name),
  }
}
