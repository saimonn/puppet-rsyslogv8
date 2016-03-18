require 'spec_helper_acceptance'

describe 'rsyslogv8' do

  context 'with log shipping' do
    context 'TCP' do
      it 'should apply without error' do
        pp = <<-EOS
          class { 'rsyslogv8': }
          rsyslogv8::config::ship { 'localhost':
            remote_port      => 514,
            remote_auth      => 'anon',
            protocol         => 'tcp',
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
            remote_port      => 514,
            remote_auth      => 'anon',
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
    end

    context 'UDP' do
      it 'should apply without error' do
        pp = <<-EOS
          class { 'rsyslogv8': }
          rsyslogv8::config::ship { 'localhost':
            remote_port      => 514,
            remote_auth      => 'anon',
            protocol         => 'udp',
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
            remote_port      => 514,
            remote_auth      => 'anon',
            protocol         => 'udp',
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

    context 'RELP' do
      it 'should apply without error' do
        pp = <<-EOS
          class { 'rsyslogv8': modules_extras => { 'omrelp' => {} } }
          rsyslogv8::config::ship { 'localhost':
            remote_port      => 514,
            remote_auth      => 'anon',
            protocol         => 'relp',
            queue_size_limit => 100000,
            queue_mode       => 'LinkedList-DA',
          }
        EOS

        apply_manifest(pp, :catch_failures => true)
      end
      it 'should idempotently run' do
        pp = <<-EOS
          class { 'rsyslogv8': modules_extras => { 'omrelp' => {} } }
          rsyslogv8::config::ship { 'localhost':
            remote_port      => 514,
            remote_auth      => 'anon',
            protocol         => 'relp',
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

  end

  context 'with log receiving' do
    context 'TCP' do
      it 'should apply without error' do
        pp = <<-EOS
          class { 'rsyslogv8':
            modules_extras => { 'imtcp' => {} }
          }
          rsyslogv8::config::receive { 'localhost':
            port             => 514,
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
            port             => 514,
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
      describe port(514) do
        it { should be_listening }
      end
    end

    context 'UDP' do
      it 'should apply without error' do
        pp = <<-EOS
          class { 'rsyslogv8':
            modules_extras => { 'imudp' => {} }
          }
          rsyslogv8::config::receive { 'localhost':
            port             => 514,
            protocol         => 'udp',
            queue_size_limit => 100000,
            queue_mode       => 'LinkedList-DA',
          }
        EOS
  
        apply_manifest(pp, :catch_failures => true)
      end
      it 'should idempotently run' do
        pp = <<-EOS
          class { 'rsyslogv8':
            modules_extras => { 'imudp' => {} }
          }
          rsyslogv8::config::receive { 'localhost':
            port             => 514,
            protocol         => 'udp',
            queue_size_limit => 100000,
            queue_mode       => 'LinkedList-DA',
          }
        EOS
  
        apply_manifest(pp, :catch_changes => true)
      end
      describe command('rsyslogd -N1') do
        its(:exit_status) { should eq 0 }
      end
      describe port(514) do
        it { should be_listening.with('udp') }
      end
    end

    context 'RELP' do
      it 'should apply without error' do
        pp = <<-EOS
          class { 'rsyslogv8':
            modules_extras => { 'imrelp' => {} }
          }
          rsyslogv8::config::receive { 'localhost':
            port             => 514,
            protocol         => 'relp',
            queue_size_limit => 100000,
            queue_mode       => 'LinkedList-DA',
          }
        EOS
  
        apply_manifest(pp, :catch_failures => true)
      end
      it 'should idempotently run' do
        pp = <<-EOS
          class { 'rsyslogv8':
            modules_extras => { 'imrelp' => {} }
          }
          rsyslogv8::config::receive { 'localhost':
            port             => 514,
            protocol         => 'relp',
            queue_size_limit => 100000,
            queue_mode       => 'LinkedList-DA',
          }
        EOS
  
        apply_manifest(pp, :catch_changes => true)
      end
      describe command('rsyslogd -N1') do
        its(:exit_status) { should eq 0 }
      end
      describe port(514) do
        it { should be_listening }
      end
    end

  end

end

