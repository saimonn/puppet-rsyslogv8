class rsyslogv8 (
) inherits rsyslogv8::params {
  include rsyslogv8::install
  include rsyslogv8::config
  include rsyslogv8::service
}

