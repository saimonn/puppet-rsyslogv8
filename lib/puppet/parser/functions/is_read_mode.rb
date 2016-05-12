#
# is_read_mode.rb
#

module Puppet::Parser::Functions
  newfunction(:is_read_mode, :type => :rvalue, :doc => <<-EOS
Function to check if the argument is a rsyslog facility name or number.

*Example:*
  is_read_mode(['notareadmode'])
  is_read_mode([1000])
  is_read_mode(['line'])
  is_read_mode([0])
EOS
  ) do |arguments|
    raise Puppet::ParseError, "is_read_mode(): Wrong number of arguments " +
        "given (#{arguments.length} required 1" unless arguments.length == 1
    raise Puppet::ParseError, "is_read_mode(): Argument must be a String or Integer given " +
        " #{arguments[0]} as #{arguments[0].class.name}" unless ( arguments[0].is_a? String  or arguments[0].is_a? Integer )

    if [
      'line', 0,
      'paragraph', 1,
      'indented', 2,
    ].include? arguments[0]
      return true
    else
      return false
    end
  end
end
