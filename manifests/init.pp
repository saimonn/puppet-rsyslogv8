class rsyslogv8 (
  $rsyslog_package_name           = $rsyslogv8::params::rsyslog_package_name,
  $gnutls_package_name            = $rsyslogv8::params::relp_package_name,
  $relp_package_name              = $rsyslogv8::params::gnutls_package_name,
  $manage_repo                    = $rsyslogv8::params::manage_repo,
  $repo_data                      = $rsyslogv8::params::repo_data,
  $package_status                 = $rsyslogv8::params::package_status,
  $run_user                       = $rsyslogv8::params::run_user,
  $run_group                      = $rsyslogv8::params::run_group,
  $spool_dir                      = $rsyslogv8::params::spool_dir,
  $modules                        = $rsyslogv8::params::modules,
  $perm_dir                       = $rsyslogv8::params::perm_dir,
  $perm_file                      = $rsyslogv8::params::perm_file,
  $umask                          = $rsyslogv8::params::umask,
  $omit_local_logging             = $rsyslogv8::params::omit_local_logging,
  $service_name                   = $rsyslogv8::params::service_name,
  $rsyslog_conf                   = $rsyslogv8::params::rsyslog_conf,
  $rsyslog_d                      = $rsyslogv8::params::rsyslog_d,
  $purge_rsyslog_d                = $rsyslogv8::params::purge_rsyslog_d,
  $preserve_fqdn                  = $rsyslogv8::params::preserve_fqdn,
  $local_host_name                = $rsyslogv8::params::local_host_name,
  $non_kernel_facility            = $rsyslogv8::params::non_kernel_facility,
  $max_message_size               = $rsyslogv8::params::max_message_size,
  $system_log_rate_limit_interval = $rsyslogv8::params::system_log_rate_limit_interval,
  $system_log_rate_limit_burst    = $rsyslogv8::params::system_log_rate_limit_burst,
  $default_template               = $rsyslogv8::params::default_template,
  $msg_reduction                  = $rsyslogv8::params::msg_reduction,
  $log_user                       = $rsyslogv8::params::log_user,
  $log_group                      = $rsyslogv8::params::log_group,
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

