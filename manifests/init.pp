class rsyslogv8 (
  $rsyslog_package_name = $rsyslogv8::params::rsyslog_package_name,
  $gnutls_package_name  = $rsyslogv8::params::relp_package_name,
  $relp_package_name    = $rsyslogv8::params::gnutls_package_name,
  $manage_repo          = $rsyslogv8::params::manage_repo,
  $repo_data            = $rsyslogv8::params::repo_data,
  $package_status       = $rsyslogv8::params::package_status,
) inherits rsyslogv8::params {
  if ! is_string($rsyslog_package_name) and $rsyslog_package_name != false {
    fail('parameter rsyslog_package_name must be a string or false')
  }
  if ! is_string($gnutls_package_name) and $gnutls_package_name != false {
    fail('parameter gnutls_package_name must be a string or false')
  }
  if ! is_string($relp_package_name) and $relp_package_name != false {
    fail('parameter relp_package_name must be a string or false')
  }
  if ! is_bool($manage_repo) {
    fail('parameter manage_repo must be a boolean')
  }
  if ! is_hash($repo_data) {
    fail('parameter rsyslogv8::params::repo_data must be a hash')
  }
  if $manage_repo and empty($repo_data) {
    fail('if manage_repo is true, repo_data must be a non-empty hash with valid data for the repository type of the osfamily')
  }
  case $package_status {
    'present', 'latest', 'absent': {}
    default: {
      fail('parameter package_status must be one of: "present", "latest", "absent"')
    }
  }

  include ::rsyslogv8::install
  include ::rsyslogv8::config
  include ::rsyslogv8::repository
  include ::rsyslogv8::service
}

