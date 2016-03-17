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
          remote_port      => 514,
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
          remote_port      => 514,
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

  context 'TLS enabled' do
    context 'self-signed cert' do
      describe command('openssl req -x509 -newkey rsa:2048 -nodes -keyout /etc/cert.key -out /etc/cert.pem -days 3 -subj /CN=localhost') do
        its(:exit_status) { should eq 0 }
      end
      context 'with log receiving TCP' do
        it 'should apply without error' do
          pp = <<-EOS
            class { 'rsyslogv8':
              modules_extras => { 'imtcp' => {} },
              ssl            => true,
              ssl_ca         => '/etc/cert.pem',
              ssl_cert       => '/etc/cert.pem',
              ssl_key        => '/etc/cert.key',
            }
            rsyslogv8::config::receive { 'localhost':
              port                    => 514,
              protocol                => 'tcp',
              queue_size_limit        => 100000,
              queue_mode              => 'LinkedList-DA',
              #remote_authorised_peers => [ 'localhost', 'foo', 'bar' ],
              #remote_auth             => 'x509/name',
            }
          EOS
  
          apply_manifest(pp, :catch_failures => true)
        end
        it 'should idempotently run' do
          pp = <<-EOS
            class { 'rsyslogv8':
              modules_extras => { 'imtcp' => {} },
              ssl            => true,
              ssl_ca         => '/etc/cert.pem',
              ssl_cert       => '/etc/cert.pem',
              ssl_key        => '/etc/cert.key',
            }
            rsyslogv8::config::receive { 'localhost':
              port                    => 514,
              protocol                => 'tcp',
              queue_size_limit        => 100000,
              queue_mode              => 'LinkedList-DA',
              #remote_authorised_peers => [ 'localhost', 'foo', 'bar' ],
              #remote_auth             => 'x509/name',
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
end

