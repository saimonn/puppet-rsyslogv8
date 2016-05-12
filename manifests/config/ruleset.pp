# Define to control rulesets.
# A ruleset can be used by inputs to handle the events differently than the default rules.
#  actions: [List[Hash]] the list of actions the ruleset contains.
#  ruleset_name: [String] the name of the ruleset as used in rsyslog
define rsyslogv8::config::ruleset (
  $actions,
  $ruleset_name = $title,
) {
  if ! is_array($actions) {
    fail('actions parameter must be an array')
  }
  ::rsyslogv8::config::snippet { "ruleset-${title}":
    content  => template("${module_name}/config/ruleset.erb"),
    priority => '20',
  }
}
