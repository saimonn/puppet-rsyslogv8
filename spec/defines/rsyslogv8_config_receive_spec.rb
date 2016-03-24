require 'spec_helper'

describe 'rsyslogv8::config::receive' do

  let (:title) { 'localhost' }

  context 'w/o global ssl' do
    let(:pre_condition) do
      "class { 'rsyslogv8': }"
    end

    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'defaults' do
          let (:params) { {
          } }

          it { should contain_rsyslogv8__config__receive('localhost')
          }
        end

        context 'when using a wrong queue_mode' do
          let (:params) { {
            :queue_mode  => 'Error',
          } }

          it 'should fail' do
            expect { should contain_rsyslogv8__config__receive('localhost')
            }.to raise_error(Puppet::Error, /unknown value .* for parameter queue_mode*/)
          end
        end

        context 'when overriding ssl parameters' do
          context 'using TCP' do
            let (:params) { {
              :protocol          => 'tcp',
              :override_ssl      => true,
              :override_ssl_cert => '/tmp/dummy.pem',
              :override_ssl_ca   => '/tmp/dummy.pem',
              :override_ssl_key  => '/tmp/dummy.pem',
            } }

            it 'should fail' do
              expect { should contain_rsyslogv8__config__receive('localhost')
              }.to raise_error(Puppet::Error, /cannot override ssl parameters for plain tcp connection/)
            end
          end

          context 'using RELP' do
            let (:params) { {
              :protocol          => 'relp',
              :override_ssl      => true,
              :override_ssl_cert => '/tmp/dummy.pem',
              :override_ssl_ca   => '/tmp/dummy.pem',
              :override_ssl_key  => '/tmp/dummy.pem',
            } }

            if facts[:osfamily] == 'RedHat' and ( facts[:operatingsystemmajrelease] == '5' or facts[:operatingsystemmajrelease] == '6' )
              it 'should fail' do
                expect { should contain_rsyslogv8__config__receive('localhost')
                }.to raise_error(Puppet::Error, /TLS with relp does NOT work/)
              end
            else
              it { should contain_rsyslogv8__config__receive('localhost')
              }
            end
          end

          context 'using UDP' do
            let (:params) { {
              :protocol          => 'udp',
              :override_ssl      => true,
              :override_ssl_cert => '/tmp/dummy.pem',
              :override_ssl_ca   => '/tmp/dummy.pem',
              :override_ssl_key  => '/tmp/dummy.pem',
            } }

            it 'should fail' do
              expect { should contain_rsyslogv8__config__receive('localhost')
              }.to raise_error(Puppet::Error, /TLS cannot be enabled using UDP/)
            end
          end

        end

      end
    end

  end

  context 'with global ssl' do
    let(:pre_condition) do
      "class { 'rsyslogv8': ssl => true, ssl_ca => '/etc/cert.pem' }"
    end

    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'defaults' do
          let (:params) { {
          } }

          it { should contain_rsyslogv8__config__receive('localhost')
          }
        end

        context 'when using a wrong queue_mode' do
          let (:params) { {
            :queue_mode  => 'Error',
          } }

          it 'should fail' do
            expect { should contain_rsyslogv8__config__receive('localhost')
            }.to raise_error(Puppet::Error, /unknown value .* for parameter queue_mode.*/)
          end
        end

        context 'when using tcp' do
          let (:params) { {
            :protocol    => 'tcp',
          } }

          it { should contain_rsyslogv8__config__receive('localhost')
          }

          context 'when using x509/name authentication' do
            context 'when not setting remote_authorised_peers' do
              let (:params) { {
                :protocol    => 'tcp',
                :remote_auth => 'x509/name',
              } }
              it 'should fail' do
                expect { should contain_rsyslogv8__config__receive('localhost')
                }.to raise_error(Puppet::Error, /must define remote_authorised_peers when authenticating hosts/)
              end
            end
          end
        end

        context 'when using relp' do
          let (:params) { {
            :protocol    => 'relp',
          } }

          if facts[:osfamily] == 'RedHat' and ( facts[:operatingsystemmajrelease] == '5' or facts[:operatingsystemmajrelease] == '6' )
            it 'should fail' do
              expect { should contain_rsyslogv8__config__receive('localhost')
              }.to raise_error(Puppet::Error, /TLS with relp does NOT work/)
            end
          else
            it { should contain_rsyslogv8__config__receive('localhost')
            }
          end

          context 'when using x509/name authentication' do
            context 'when not setting remote_authorised_peers' do
              let (:params) { {
                :protocol    => 'relp',
                :remote_auth => 'x509/name',
              } }
              it 'should fail' do
                expect { should contain_rsyslogv8__config__receive('localhost')
                }.to raise_error(Puppet::Error, /must define remote_authorised_peers when authenticating hosts/)
              end
            end
          end
        end

        context 'when overriding ssl parameters' do
          context 'using TCP' do
            let (:params) { {
              :protocol          => 'tcp',
              :override_ssl      => true,
              :override_ssl_cert => '/tmp/dummy.pem',
              :override_ssl_ca   => '/tmp/dummy.pem',
              :override_ssl_key  => '/tmp/dummy.pem',
            } }

            it 'should fail' do
              expect { should contain_rsyslogv8__config__receive('localhost')
              }.to raise_error(Puppet::Error, /cannot override ssl parameters for plain tcp connection/)
            end
          end

          context 'using RELP' do
            let (:params) { {
              :protocol          => 'relp',
              :override_ssl      => true,
              :override_ssl_cert => '/tmp/dummy.pem',
              :override_ssl_ca   => '/tmp/dummy.pem',
              :override_ssl_key  => '/tmp/dummy.pem',
            } }

            if facts[:osfamily] == 'RedHat' and ( facts[:operatingsystemmajrelease] == '5' or facts[:operatingsystemmajrelease] == '6' )
              it 'should fail' do
                expect { should contain_rsyslogv8__config__receive('localhost')
                }.to raise_error(Puppet::Error, /TLS with relp does NOT work/)
              end
            else
              it { should contain_rsyslogv8__config__receive('localhost')
              }
            end
          end

          context 'using UDP' do
            let (:params) { {
              :protocol          => 'udp',
              :override_ssl      => true,
              :override_ssl_cert => '/tmp/dummy.pem',
              :override_ssl_ca   => '/tmp/dummy.pem',
              :override_ssl_key  => '/tmp/dummy.pem',
            } }

            it 'should fail' do
              expect { should contain_rsyslogv8__config__receive('localhost')
              }.to raise_error(Puppet::Error, /TLS cannot be enabled using UDP/)
            end
          end
        end

      end
    end
  end

end
