#
# get_log_level_number.rb
#

module Puppet::Parser::Functions
  newfunction(:get_log_level_number, :type => :rvalue, :doc => <<-EOS
Function to get the rsyslog log level number from name, for simple use also takes the number.

*Example:*
  get_log_level_number(['notaloglevel'])
  get_log_level_number([1000])
  get_log_level_number(['debug'])
  get_log_level_number([7])
EOS
  ) do |arguments|
    raise Puppet::ParseError, "get_log_level_number(): Wrong number of arguments " +
        "given (#{arguments.size} required 1" unless arguments.length == 1
    raise Puppet::ParseError, "get_log_level_number(): Argument must be a String or Integer given " +
        " #{arguments[0]} as #{arguments[0].class.name}" unless ( arguments[0].is_a? String  or arguments[0].is_a? Integer )
    case arguments[0]
      when 'emerg', 0
        return 0
      when 'alert', 1
        return 1
      when 'crit', 2
        return 2
      when 'error', 3
        return 3
      when 'warning', 4
        return 4
      when 'notice', 5
        return 5
      when 'info', 6
        return 6
      when 'debug', 7
        return 7
      else
        return nil
    end
  end
end
