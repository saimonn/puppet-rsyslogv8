#
# sub_template_call.rb
#

class ERBContext
  def initialize(hash, myscope)
    @scope = myscope
    hash.each_pair do |key, value|
      instance_variable_set('@' + key.to_s, value)
    end
  end

  def scope
    @scope
  end

  def get_binding
    binding
  end
end

module Puppet::Parser::Functions
  newfunction(:sub_template_call, :type => :rvalue, :doc => <<-EOS
Work around a limitation in the puppet handling of templates.
We want to be able to include sub-templates and have proper separation on the scopes.
The only way to do it cleanly was to use directly the ERB class.
First argument is a strandard puppet template locator: $module_name/$directory_tree/$template_name
Second optional argument is a hash of variables that will be accessible from the template.

The template will always receive the puppet "scope" variable to get access to global variables and fuctions.

*Example:*
  sub_template_call(['mymodule1/template_with_args.erb', { 'variable1_name' => $value1, 'variable2_name' => $value2 }])
  sub_template_call(['mymodule2/template_without_args.erb'])
EOS
  ) do |arguments|

    raise(Puppet::ParseError, "sub_template_call(): Wrong number of arguments " +
       "given (#{arguments.size} required 1 (template name) or 2 (template name " +
       "with variable hash))") if arguments.size != 1 and arguments.size != 2
    template_name = arguments[0]
    variables_hash = arguments[1]

    raise Puppet::ParseError, "sub_template_call(): First argument must be a string" unless template_name.is_a? String
    raise Puppet::ParseError, "sub_template_call(): Second argument must be a hash" unless variables_hash.is_a? Hash

    # get template full path from standard puppet template locator
    template_full_path = Puppet::Parser::Files::find_template(template_name, Puppet.lookup(:current_environment))
    raise Puppet::ParseError, "sub_template_call(): unknown template #{template_name}" unless template_full_path
    # instanciate the template engine using the template content, last argument is a *global* variable name, if the same is used
    # in nested ERBs the child overwrites what the parent made, so we set it to a (hopefully) globally unique name.
    template_engine = ERB.new(File.read(template_full_path), 0, '-', "erbout" + Digest::MD5.hexdigest(template_full_path))
    # set the filename for error messages
    template_engine.filename = template_name
    # create a new scope to set the local variables
    template_scope = ERBContext.new(variables_hash, self)

    #template_scope.local_variable_set('scope', self)
    #variables_hash.each_pair do |k, v|
    #  raise Puppet::ParseError, "sub_template_call(): Second argument must be a hash with all key being Strings received a #{k.class.name}" unless k.is_a? String
    #  template_scope.local_variable_set(k, v)
    #end
    # instanciate the template and return the value
    begin
      return template_engine.result(template_scope.get_binding)
    rescue => detail
      info = detail.backtrace.first.split(':')
      raise Puppet::ParseError,"Failed to parse template #{template_name}:\n  Filepath: #{info[0]}\n  Line: #{info[1]}\n  Detail: #{detail}\n"
    end
  end
end
