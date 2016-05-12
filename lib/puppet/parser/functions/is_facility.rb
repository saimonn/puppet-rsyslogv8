#
# is_facility.rb
#

module Puppet::Parser::Functions
  newfunction(:is_facility, :type => :rvalue, :doc => <<-EOS
Function to check if the argument is a rsyslog facility name or number.

*Example:*
  is_facility(['notafacility'])
  is_facility([1000])
  is_facility(['kern'])
  is_facility([0])
EOS
  ) do |arguments|
    raise Puppet::ParseError, "is_facility(): Wrong number of arguments " +
        "given (#{arguments.length} required 1" unless arguments.length == 1

    raise Puppet::ParseError, "is_facility(): Argument must be a String or Integer given " +
        " #{arguments[0]} as #{arguments[0].class.name}" unless ( arguments[0].is_a? String  or arguments[0].is_a? Integer )
    if [
          'kern', 0,
          'user', 1,
          'mail', 2,
          'daemon', 3,
          'auth', 4,
          'syslog', 5,
          'lpr', 6,
          'news', 7,
          'uucp', 8,
          'cron', 9,
          'security', 'authpriv', 10,
          'ftp', 11,
          'ntp', 12,
          'logaudit', 13,
          'logalert', 14,
          'clock', 15,
          'local0', 16,
          'local1', 17,
          'local2', 18,
          'local3', 19,
          'local4', 20,
          'local5', 21,
          'local6', 22,
          'local7', 23
        ].include? arguments[0]
      return true
    else
      return false
    end
  end
end

