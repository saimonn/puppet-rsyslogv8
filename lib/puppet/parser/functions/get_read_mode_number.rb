#
# get_read_mode_number.rb
#

module Puppet::Parser::Functions
  newfunction(:get_read_mode_number, :type => :rvalue, :doc => <<-EOS
Function to get the rsyslog log level number from name, for simple use also takes the number.

*Example:*
  get_read_mode_number(['notareadmode'])
  get_read_mode_number([1000])
  get_read_mode_number(['line'])
  get_read_mode_number([1])
EOS
  ) do |arguments|
    raise Puppet::ParseError, "get_read_mode_number(): Wrong number of arguments " +
        "given (#{arguments.size} required 1" unless arguments.length == 1
    raise Puppet::ParseError, "get_read_mode_number(): Argument must be a String or Integer given " +
        " #{arguments[0]} as #{arguments[0].class.name}" unless ( arguments[0].is_a? String  or arguments[0].is_a? Integer )
    case arguments[0]
      when 'line', 0
        return 0
      when 'paragraph', 1
        return 1
      when 'indented', 2
        return 2
      else
        return nil
    end
  end
end
