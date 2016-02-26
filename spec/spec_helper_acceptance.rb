require 'beaker-rspec'
require 'beaker_spec_helper'

include BeakerSpecHelper

hosts.each do |host|

  if host['platform'] =~ /^ubuntu-(15.04|15.10)-/
    on host, "wget -O /tmp/puppet.deb http://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb"
    on host, "dpkg -i --force-all /tmp/puppet.deb"
    on host, "apt-get update"
    host.install_package('puppet-agent')
  else
    install_puppet_agent_on host, {}
  end

  # Install git so that we can install modules from github
  if host['platform'] =~ /^el-5-/
    # git is only available on EPEL for el-5
    install_package host, 'epel-release'
  end
  install_package host, 'git'

  on host, "puppet cert generate $(facter fqdn)"
end

RSpec.configure do |c|
  module_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  module_name = module_root.split('-').last

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => module_root, :module_name => module_name)
    hosts.each do |host|
      BeakerSpecHelper::spec_prep(host)
    end
  end
end

# Load all shared contexts and shared examples
dir = Pathname.new(__FILE__).parent
Dir["#{dir}/support/**/*.rb"].sort.each {|f| require f}

