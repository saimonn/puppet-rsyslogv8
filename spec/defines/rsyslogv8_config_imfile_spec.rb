require 'spec_helper'

describe 'rsyslogv8::config::imfile' do
  let (:title) { 'install-log' }
  let (:pre_condition) do
    "class { 'rsyslogv8': }"
  end
  on_supported_os.each do |os, facts|
    case facts[:osfamily]
      when 'Debian'
        let (:params) { { 'files' => [ '/var/log/dpkg.log' ] } }
      when 'RedHat'
        let (:params) { { 'files' => [ '/var/log/yum.log' ] } }
    end
    let (:facts) do
      facts
    end
    context 'defaults' do

      it { should contain_rsyslogv8__config__imfile('install-log')
      }

    end
  end

end
