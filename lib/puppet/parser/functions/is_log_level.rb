#
# is_log_level.rb
#

module Puppet::Parser::Functions
  newfunction(:is_log_level, :type => :rvalue, :doc => <<-EOS
Function to check if the argument is a rsyslog log level name or number.

*Example:*
  is_log_level(['notaloglevel'])
  is_log_level([1000])
  is_log_level(['debug'])
  is_log_level([0])
EOS
  ) do |arguments|
    raise Puppet::ParseError, "is_log_level(): Wrong number of arguments " +
        "given (#{arguments.size} required 1" unless arguments.length == 1
    raise Puppet::ParseError, "is_log_level(): Argument must be a String or Integer given " +
        " #{arguments[0]} as #{arguments[0].class.name}" unless ( arguments[0].is_a? String  or arguments[0].is_a? Integer )

    if [
          'emerg', 0,
          'alert', 1,
          'crit', 2,
          'error', 3,
          'warning', 4,
          'notice', 5,
          'info', 6,
          'debug', 7
        ].include? arguments[0]
      return true
    else
      return false
    end
  end
end
