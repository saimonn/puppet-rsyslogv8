#
class rsyslogv8::config::default_receive_ruleset (
  $base_dir = '/srv/log',
) {
  $ruleset_name = 'default_receive_ruleset'
  $actions = [
    {
      'type'     => 'omfile',
      'name'     => 'auth',
      'selector' => 'auth,authpriv.*',
      'dynafile' => 'receiveAuthFile',
    },
    {
      'type'     => 'omfile',
      'name'     => 'syslog',
      'selector' => '*.*;auth,authpriv.none,mail.none,cron.none',
      'dynafile' => 'receiveSyslogFile',
    },
    {
      'type'     => 'omfile',
      'name'     => 'cron',
      'selector' => 'cron.*',
      'dynafile' => 'receiveCronFile',
    },
    {
      'type'     => 'omfile',
      'name'     => 'daemon',
      'selector' => 'daemon.*',
      'dynafile' => 'receiveDaemonFile',
    },
    {
      'type'     => 'omfile',
      'name'     => 'kern',
      'selector' => 'kern.*',
      'dynafile' => 'receiveKernFile',
    },
    {
      'type'     => 'omfile',
      'name'     => 'mail',
      'selector' => 'mail.*',
      'dynafile' => 'receiveMailFile',
    },
    {
      'type'     => 'omfile',
      'name'     => 'user',
      'selector' => 'user.*',
      'dynafile' => 'receiveUserFile',
    },
    {
      'type'     => 'omfile',
      'name'     => 'debug',
      'selector' => '*.=info;*.=notice;*.=warn;auth.none,authpriv.none,cron.none,daemon.none,mail.none,news.none',
      'dynafile' => 'receiveDebugFile',
    },
    {
      'type'     => 'omfile',
      'name'     => 'messages',
      'selector' => ':programname, isequal, "audispd"',
      'dynafile' => 'receiveMessagesFile',
    },
  ]

  $templates = [
    {
      'name'   => 'receiveAuthFile',
      'type'   => 'string',
      'string' => "${base_dir}/%source:R,ERE,1,DFLT:([A-Za-z0-9.-]*)--end%/auth.log",
    },
    {
      'name'   => 'receiveSyslogFile',
      'type'   => 'string',
      'string' => "${base_dir}/%source:R,ERE,1,DFLT:([A-Za-z0-9.-]*)--end%/syslog",
    },
    {
      'name'   => 'receiveCronFile',
      'type'   => 'string',
      'string' => "${base_dir}/%source:R,ERE,1,DFLT:([A-Za-z0-9.-]*)--end%/cron.log",
    },
    {
      'name'   => 'receiveDaemonFile',
      'type'   => 'string',
      'string' => "${base_dir}/%source:R,ERE,1,DFLT:([A-Za-z0-9.-]*)--end%/daemon.log",
    },
    {
      'name'   => 'receiveKernFile',
      'type'   => 'string',
      'string' => "${base_dir}/%source:R,ERE,1,DFLT:([A-Za-z0-9.-]*)--end%/kern.log",
    },
    {
      'name'   => 'receiveMailFile',
      'type'   => 'string',
      'string' => "${base_dir}/%source:R,ERE,1,DFLT:([A-Za-z0-9.-]*)--end%/mail.log",
    },
    {
      'name'   => 'receiveUserFile',
      'type'   => 'string',
      'string' => "${base_dir}/%source:R,ERE,1,DFLT:([A-Za-z0-9.-]*)--end%/user.log",
    },
    {
      'name'   => 'receiveDebugFile',
      'type'   => 'string',
      'string' => "${base_dir}/%source:R,ERE,1,DFLT:([A-Za-z0-9.-]*)--end%/debug",
    },
    {
      'name'   => 'receiveMessagesFile',
      'type'   => 'string',
      'string' => "${base_dir}/%source:R,ERE,1,DFLT:([A-Za-z0-9.-]*)--end%/messages",
    },
  ]

  rsyslogv8::config::snippet { 'default_receive_ruleset':
    priority => '00',
    content  => template("${module_name}/config/templates.erb", "${module_name}/config/ruleset.erb"),
  }
}
