require 'spec_helper_acceptance'

describe 'rsyslogv8' do

  context 'with imfiles' do
    case fact(:osfamily)
      when 'RedHat'
        path = '/var/log/yum.log'
      when 'Debian'
        path = '/var/log/dpkg.log'
    end
    it 'should apply without error' do
      pp = <<-EOS
        class { 'rsyslogv8':
          modules_extras => { 'imfile' => {} }
        }
        class { 'rsyslogv8::config::local': }
        rsyslogv8::config::imfile { '#{path}': }
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'should idempotently run' do
      pp = <<-EOS
        class { 'rsyslogv8':
          modules_extras => { 'imfile' => {} }
        }
        class { 'rsyslogv8::config::local': }
        rsyslogv8::config::imfile { '#{path}': }
      EOS

      apply_manifest(pp, :catch_changes => true)
    end
    describe command('rsyslogd -N1') do
      its(:exit_status) { should eq 0 }
    end
  end

end


