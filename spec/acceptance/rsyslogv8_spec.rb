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

  context 'with log shipping TCP without TLS' do
    it 'should apply without error' do
      pp = <<-EOS
        class { 'rsyslogv8': }
        rsyslogv8::config::ship { 'localhost':
          remote_port      => 11111,
          remote_auth      => 'anon',
          queue_size_limit => 100000,
          queue_mode       => 'LinkedList-DA',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'should idempotently run' do
      pp = <<-EOS
        class { 'rsyslogv8': }
        rsyslogv8::config::ship { 'localhost':
          remote_port      => 11111,
          remote_auth      => 'anon',
          queue_size_limit => 100000,
          queue_mode       => 'LinkedList-DA',
        }
      EOS

      apply_manifest(pp, :catch_changes => true)
    end
    describe command('rsyslogd -N1') do
      its(:exit_status) { should eq 0 }
    end
  end

  context 'with log receiving TCP without TLS' do
    it 'should apply without error' do
      pp = <<-EOS
        class { 'rsyslogv8':
          modules_extras => { 'imtcp' => {} }
        }
        rsyslogv8::config::receive { 'localhost':
          port             => 11112,
          protocol         => 'tcp',
          queue_size_limit => 100000,
          queue_mode       => 'LinkedList-DA',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
    end
    it 'should idempotently run' do
      pp = <<-EOS
        class { 'rsyslogv8':
          modules_extras => { 'imtcp' => {} }
        }
        rsyslogv8::config::receive { 'localhost':
          port             => 11112,
          protocol         => 'tcp',
          queue_size_limit => 100000,
          queue_mode       => 'LinkedList-DA',
        }
      EOS

      apply_manifest(pp, :catch_changes => true)
    end
    describe command('rsyslogd -N1') do
      its(:exit_status) { should eq 0 }
    end
    describe port(11112) do
      it { should be_listening }
    end
  end
end

