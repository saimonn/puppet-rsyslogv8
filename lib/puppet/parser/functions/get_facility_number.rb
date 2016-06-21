#
# get_facility_number.rb
#

module Puppet::Parser::Functions
  newfunction(:get_facility_number, :type => :rvalue, :doc => <<-EOS
Function to get the rsyslog facility number from name, for simple use also takes the number.

*Example:*
  get_facility_number(['notafacility'])
  get_facility_number([1000])
  get_facility_number(['kern'])
  get_facility_number([0])
EOS
  ) do |arguments|
    raise Puppet::ParseError, "get_facility_number(): Wrong number of arguments " +
        "given (#{arguments.length} required 1" unless arguments.length == 1
    raise Puppet::ParseError, "get_facility_number(): Argument must be a String or Integer given " +
        " #{arguments[0]} as #{arguments[0].class.name}" unless ( arguments[0].is_a? String  or arguments[0].is_a? Integer )

    case arguments[0]
      when 'kern', 0
        return 0
      when 'user', 1
        return 1
      when 'mail', 2
        return 2
      when 'daemon', 3
        return 3
      when 'auth', 4
        return 4
      when 'syslog', 5
        return 5
      when 'lpr', 6
        return 6
      when 'news', 7
        return 7
      when 'uucp', 8
        return 8
      when 'cron', 9
        return 9
      when 'security', 'authpriv', 10
        return 10
      when 'ftp', 11
        return 11
      when 'ntp', 12
        return 12
      when 'logaudit', 13
        return 13
      when 'logalert', 14
        return 14
      when 'clock', 15
        return 15
      when 'local0', 16
        return 16
      when 'local1', 17
        return 17
      when 'local2', 18
        return 18
      when 'local3', 19
        return 19
      when 'local4', 20
        return 20
      when 'local5', 21
        return 21
      when 'local6', 22
        return 22
      when 'local7', 23
        return 23
      else
        return nil
    end
  end
end


