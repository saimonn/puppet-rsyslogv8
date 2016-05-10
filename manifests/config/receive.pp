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
#  override_ssl_ca: [String] override absolute path to the CA file, NOT avaiable for tcp
#  override_ssl_cert: [String] override absolute path to the cert file, NOT avaiable for tcp
#  override_ssl_key: [String] override absolute path to the key file, NOT avaiable for tcp
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
  $override_ssl_ca         = false,
  $override_ssl_cert       = false,
  $override_ssl_key        = false,
  $port                    = undef,
) {
  # Input checking
  if ! is_string($queue_mode) {
    fail('parameter queue_mode must be a string')
  }
  if ! is_string($protocol) {
    fail('parameter protocol must be a string')
  }

  if $ruleset_name != undef and ! is_string($ruleset_name) {
    fail('parameter ruleset_name must be a string or undef')
  }

  if $override_ssl != undef and ! is_bool($override_ssl) {
    fail('parameter override_ssl must be a boolean or undef')
  }
  if $override_ssl_ca != false {
    validate_absolute_path($override_ssl_ca)
  }
  if $override_ssl_key != false {
    validate_absolute_path($override_ssl_key)
  }
  if $override_ssl_cert != false {
    validate_absolute_path($override_ssl_cert)
  }

  # Local variables definitions for template and semantic checking of input
  case $queue_mode {
    'LinkedList-DA': {
      $_queue_mode = 'LinkedList'
      $_queue_filename = $queue_filename
    }
    'LinkedList': {
      $_queue_mode = 'LinkedList'
      $_queue_filename = undef
    }
    'Disk': {
      $_queue_mode = 'Disk'
      $_queue_filename = $queue_filename
    }
    'FixedArray': {
      $_queue_mode = 'FixedArray'
      $_queue_filename = undef
    }
    'FixedArray-DA': {
      $_queue_mode = 'FixedArray'
      $_queue_filename = $queue_filename
    }
    default: {
      fail("unknown value '${queue_mode}' for parameter queue_mode")
    }
  }

  case $protocol {
    'tcp': {
      $_imodule = 'imtcp'
      if $override_ssl != undef {
        fail('cannot override ssl parameters for plain tcp connection consider using ssl globally or imrelp')
      }
      if $remote_auth != 'anon' or $remote_authorised_peers != undef {
        fail('cannot override TCP auth settings per listen point, set the global parameters of the imtcp module')
      }
    }

    'relp': {
      $_imodule = 'imrelp'
    }

    'udp': {
      $_imodule = 'imudp'
      if $::rsyslogv8::ssl or $override_ssl {
        fail('TLS cannot be enabled using UDP consider using imrelp or imtcp')
      }
    }

    default: {
      fail("unsupported protocol '${protocol}'")
    }
  }

  if $ruleset_name != undef {
    $_real_ruleset_name = $ruleset_name
  } else {
    include ::rsyslogv8::config::default_receive_ruleset
    $_real_ruleset_name = 'default_receive_ruleset'
  }

  # create config snippet using template
  ::rsyslogv8::config::snippet { "receive-${title}":
    content  => template("${module_name}/config/receive.erb"),
    priority => '50',
  }
}

