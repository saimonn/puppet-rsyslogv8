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

        context 'when using relp' do
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

      end
    end
  end

end
