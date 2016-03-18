require 'spec_helper_acceptance'

describe 'rsyslogv8' do

  context 'with defaults' do
    it 'should apply without error' do
      pp = <<-EOS
        class { 'rsyslogv8': }
        class { 'rsyslogv8::config::local': }
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'should idempotently run' do
      pp = <<-EOS
        class { 'rsyslogv8': }
        class { 'rsyslogv8::config::local': }
      EOS

      apply_manifest(pp, :catch_changes => true)
    end
    describe command('rsyslogd -N1') do
      its(:exit_status) { should eq 0 }
    end
  end

end

