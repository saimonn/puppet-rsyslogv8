require 'spec_helper'

describe 'rsyslogv8::config::ship' do

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

          it { should contain_rsyslogv8__config__ship('localhost')
          }
        end

        context 'when using a wrong queue_mode' do
          let (:params) { {
            :queue_mode  => 'Error',
          } }

          it 'should fail' do
            expect { should contain_rsyslogv8__config__ship('localhost')
            }.to raise_error(Puppet::Error, /unknown value .* for parameter queue_mode*/)
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

          it { should contain_rsyslogv8__config__ship('localhost')
          }
        end

        context 'when using a wrong queue_mode' do
          let (:params) { {
            :queue_mode  => 'Error',
          } }

          it 'should fail' do
            expect { should contain_rsyslogv8__config__ship('localhost')
            }.to raise_error(Puppet::Error, /unknown value .* for parameter queue_mode.*/)
          end
        end

        context 'protocol is tcp' do
          context 'setting x509/name authentication' do
            let (:params) { {
              :remote_auth => 'x509/name',
              :protocol    => 'tcp',
            } }

            it { should contain_rsyslogv8__config__ship('localhost')
            }
          end

          context 'overriding ssl parameters' do
            let (:params) { {
              :override_ssl => true,
              :protocol     => 'tcp',
            } }

            it 'should fail' do
              expect { should contain_rsyslogv8__config__ship('localhost')
              }.to raise_error(Puppet::Error, /.*cannot override ssl parameters for plain tcp connection consider using relp if you really want this feature.*/)
            end
          end

        end

      end
    end
  end
end
