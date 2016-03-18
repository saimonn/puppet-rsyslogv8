# Define to receive logs from a remote server and manage them.
#  queue_size_limit: [Integer|undef] Maximum number of events in the queue
#  queue_batch_size: [Integer] Maximum number of events taken from the queue at once to be processed in batch
#  enqueue_timeout: [Integer] (ms) before dropping waiting incoming events
#  queue_mode: [Enum] Mode for the queue. Supported Values: "LinkedList" (pure in memory, dynamic), "LinkedList-DA" (in memory, dynamic, Disk-Assisted), ...
#  queue_filename: [String] The name of the queue in rsyslog
#  queue_max_disk_space: [String] Size of the maximum disk space a queue can take, if mode is compatible
#  queue_save_on_shutdown: [Boolean] if queue_mode allows it, the queue is saved to disk when rsyslog is shutdown
#  protocol: [Enum] protocol used for sending, can be "tcp", "udp", "relp", ... if an input module is needed, it must be enabled separately
#  remote_auth: [Enum] remote authentication method. Supported Values: "x509/name" (if ssl enabled use CN), "anon" (no auth)
#  remote_authorised_peers: [LIST[FQDN|IP]] if remote_auth is "x509/name" the list of FQDN/IP that will match, can contain wildcards
#  ruleset_name: [String] name of the (user-defined) ruleset to use for the input, if undef a ruleset will be created to write files locally
#  override_ssl: [Boolean|undef] should this configuration override global ssl flag (undef do not override, boolean is overrided value) NOT avaiable for TCP/UDP connections
#  port: [Integer|undef] port number to use for listening, undef for default
define rsyslogv8::config::receive (
  $queue_size_limit        = undef,
  $queue_batch_size        = 16,
  $enqueue_timeout         = 2000,
  $queue_mode              = 'LinkedList-DA',
  $queue_filename          = "queue-ship-${title}",
  $queue_max_disk_space    = '2g',
  $queue_save_on_shutdown  = true,
  $protocol                = 'tcp',
  $remote_auth             = 'anon',
  $remote_authorised_peers = undef,
  $ruleset_name            = undef,
  $override_ssl            = undef,
  $port                    = undef,
) {
  include ::rsyslogv8::config::receive_templates
  # Input checking
  if $queue_size_limit != undef and ! is_integer($queue_size_limit) {
    fail('parameter queue_size_limit must be an integer or undef')
  }
  if $queue_batch_size != undef and ! is_integer($queue_batch_size) {
    fail('parameter queue_batch_size must be an integer or undef')
  }
  if ! is_integer($enqueue_timeout) {
    fail('parameter enqueue_timeout must be an integer or undef')
  }
  if ! is_string($queue_mode) {
    fail('parameter queue_mode must be a string')
  }
  if ! is_string($queue_max_disk_space) {
    fail('parameter queue_max_disk_space must be a string')
  }
  if ! is_bool($queue_save_on_shutdown) {
    fail('parameter queue_save_on_shutdown must be a boolean')
  }
  if ! is_string($queue_filename) {
    fail('parameter queue_filename must be a string')
  }

  if ! is_string($protocol) {
    fail('parameter protocol must be a string')
  }

  if ! is_string($remote_auth) {
    fail('parameter remote_auth must be a string')
  }

  if $remote_authorised_peers != undef and ( (! is_array($remote_authorised_peers)) or empty($remote_authorised_peers) ) {
    fail('parameter remote_authorised_peers must be an non-empty array or undef')
  }

  if $ruleset_name != undef and ! is_string($ruleset_name) {
    fail('parameter ruleset_name must be a string or undef')
  }

  if $override_ssl != undef and ! is_bool($override_ssl) {
    fail('parameter override_ssl must be a boolean or undef')
  }

  if $port != undef and ! is_integer($port) {
    fail('parameter port must be an integer or undef')
  }

  # Local variables definitions for template and semantic checking of input
  case $queue_mode {
    'LinkedList-DA': {
      $_queue_mode = 'LinkedList'
      $_queue_disk = true
    }
    'LinkedList': {
      $_queue_mode = 'LinkedList'
      $_queue_disk = false
    }
    'Disk': {
      $_queue_mode = 'Disk'
      $_queue_disk = true
    }
    'FixedArray': {
      $_queue_mode = 'FixedArray'
      $_queue_disk = false
    }
    'FixedArray-DA': {
      $_queue_mode = 'FixedArray'
      $_queue_disk = true
    }
    default: {
      fail("unknown value '${queue_mode}' for parameter queue_mode")
    }
  }

  if $override_ssl != undef {
    $_ssl = $override_ssl
  } else {
    $_ssl = $rsyslogv8::ssl
  }

  case $remote_auth {
    'anon': {
      if $remote_authorised_peers {
        fail('cannot have peer list in anon auth mode')
      }
    }
    'x509/name': {
      if ! $_ssl {
        fail('::rsyslogv8::ssl must be enabled to authenticate using x509/name')
      }
      if $remote_authorised_peers == undef {
        fail('must define remote_authorised_peers when authenticating hosts')
      }
    }
    default: {
      fail("unknown value '${remote_auth}' for parameter remote_auth")
    }
  }

  case $protocol {
    'tcp': {
      $_imodule = 'imtcp'
      #$_remote_authorised_peers_real_option_name = 'PermittedPeer'
      $_remote_authorised_peers_real_option_name = undef
      case $remote_auth {
        'anon': {
          $_ssl_extra_options = undef
        }
        'x509/name': {
          # $_ssl_extra_options = ' StreamDriver.AuthMode="x509/name"'
          $_ssl_extra_options = undef
          fail('listen-time authentication definition is not supported in tcp use relp, or change imtcp global options StreamDriver.AuthMode and PermittedPeer')
        }
        default: {
          fail('do not know what to do with remote_auth value, please fix it')
        }
      }
    }

    'relp': {
      $_imodule = 'imrelp'
      $_remote_authorised_peers_real_option_name = 'tls.permittedpeer'
      case $remote_auth {
        'anon': {
          $_ssl_extra_options = undef
        }
        'x509/name': {
          $_ssl_extra_options = ' tls.authMode="anon"'
        }
        default: {
          fail('do not know what to do with remote_auth value, please fix it')
        }
      }
    }

    'udp': {
      $_imodule = 'imudp'
      $_remote_authorised_peers_real_option_name = undef
      if $remote_auth != 'anon' {
        fail('cannot authenticate hosts using udp, use tcp or relp instead')
      }
      $_ssl_extra_options = undef
    }

    default: {
      fail("unsupported protocol '${protocol}'")
    }
  }

  if $ruleset_name != undef {
    $_define_local_ruleset = false
    $_real_ruleset_name = $ruleset_name
  } else {
    $_define_local_ruleset = true
    $_real_ruleset_name = "input-${protocol}-${title}"
  }

  # create config snippet using template
  ::rsyslogv8::config::snippet { "receive-${title}":
    content  => template("${module_name}/config/receive.erb"),
    priority => 50,
  }
}

