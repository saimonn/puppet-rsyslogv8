class rsyslogv8 (
  $rsyslog_package_name           = $rsyslogv8::params::rsyslog_package_name,
  $relp_package_name              = $rsyslogv8::params::relp_package_name,
  $gnutls_package_name            = $rsyslogv8::params::gnutls_package_name,
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
  $service_name                   = $rsyslogv8::params::service_name,
  $rsyslog_conf                   = $rsyslogv8::params::rsyslog_conf,
  $rsyslog_d                      = $rsyslogv8::params::rsyslog_d,
  $purge_rsyslog_d                = $rsyslogv8::params::purge_rsyslog_d,
  $preserve_fqdn                  = $rsyslogv8::params::preserve_fqdn,
  $local_host_name                = $rsyslogv8::params::local_host_name,
  $max_message_size               = $rsyslogv8::params::max_message_size,
  $default_template               = $rsyslogv8::params::default_template,
  $log_user                       = $rsyslogv8::params::log_user,
  $log_group                      = $rsyslogv8::params::log_group,
  $ssl                            = false,
  $ssl_ca                         = undef,
  $ssl_cert                       = undef,
  $ssl_key                        = undef,
  $modules_extras                 = undef,
) inherits rsyslogv8::params {
  if ! is_string($rsyslog_package_name) and $rsyslog_package_name != false {
    fail('parameter rsyslog_package_name must be a string or false')
  }
  if ! is_string($perm_dir) {
    fail('parameter perm_dir must be a string')
  }
  if ! is_string($perm_file) {
    fail('parameter perm_file must be a string')
  }
  if $umask != false and ! is_string($umask) {
    fail('parameter umask must be a string or false')
  }
  if ! is_string($run_user) {
    fail('parameter run_user must be a string')
  }
  if ! is_string($service_name) {
    fail('parameter service_name must be a string')
  }
  if ! is_string($run_group) {
    fail('parameter run_group must be a string')
  }
  if ! is_string($gnutls_package_name) and $gnutls_package_name != false {
    fail('parameter gnutls_package_name must be a string or false')
  }
  if ! is_hash($modules) {
    fail('parameter modules must be a hash')
  }
  if $modules_extras != undef and ! is_hash($modules_extras) {
    fail('parameter modules_extras must be an array or undef')
  }
  if ! is_bool($purge_rsyslog_d) {
    fail('parameter purge_rsyslog_d must be a boolean')
  }
  if ! is_string($spool_dir) and ! is_absolute_path($spool_dir) {
    fail('parameter spool_dir must be an absolute path')
  }
  if ! is_string($rsyslog_d) and ! is_absolute_path($rsyslog_d) {
    fail('parameter rsyslog_d must be an absolute path')
  }
  if ! is_string($rsyslog_conf) and ! is_absolute_path($rsyslog_conf) {
    fail('parameter rsyslog_conf must be an absolute path')
  }
  if ! is_bool($preserve_fqdn) {
    fail('parameter preserve_fqdn must be a boolean')
  }
  if ! is_string($relp_package_name) and $relp_package_name != false {
    fail('parameter relp_package_name must be a string or false')
  }
  if ! is_string($local_host_name) and ! is_domain_name($local_host_name) {
    fail('parameter local_host_name must be a valid hostname')
  }
  if ! is_string($max_message_size) {
    fail('parameter max_message_size must be a string')
  }
  if ! is_string($default_template) {
    fail('parameter default_template must be a string')
  }
  if ! is_string($log_group) {
    fail('parameter log_group must be a string')
  }
  if ! is_string($log_user) {
    fail('parameter log_user must be a string')
  }
  if ! is_bool($manage_repo) {
    fail('parameter manage_repo must be a boolean')
  }
  if ! is_bool($ssl) {
    fail('parameter ssl must be a boolean')
  }
  if ! is_string($ssl_ca) {
    fail('parameter ssl_ca must be an aboslute path to the CA file')
  }
  if $ssl_cert != undef and ! is_string($ssl_cert) and ! is_absolute_path($ssl_cert) {
    fail('parameter ssl_cert must be an aboslute path to the cert file or undef')
  }
  if $ssl_key != undef and ! is_string($ssl_key) and ! is_aboslute_path($ssl_key) {
    fail('parameter ssl_key must be an absolute path to the key file or undef')
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

