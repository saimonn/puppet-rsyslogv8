# OS Specific Defaults for ::rsyslogv8 can be overriden as class parameter.
# Definition structure is as follows:
# - Global value (name also used as parameter name in ::rsyslogv8)
# - OS Family value (Global name prepended by "_family_") override global default
# - OS Specific value (Family name prepended by "_os") override family default
# - OS Version Specific value (OS Specific name prepended by "_version") override os specific value
# defined in reverse order in the file
class rsyslogv8::params {

  case $::osfamily {
    'debian': {
      $_family_manage_repo          = undef
      $_family_repo_data            = undef
      $_family_relp_package_name    = undef
      $_family_rsyslog_package_name = undef
      $_family_gnutls_package_name  = undef
      case $::operatingsystem {
        'Debian': {
          $_os_family_manage_repo          = true
          $_os_family_repo_data            = {
            'location' => 'http://debian.adiscon.com/v8-stable',
            'key'      => '1362E120FE08D280780169DC894ECF17AEF0CF8E',
            'release'  => "${::lsbdistcodename}/",
            'include'  => { 'source' => false },
            'repos'    => '',
            'pin'      => 1001,
          }
          $_os_family_relp_package_name    = undef
          $_os_family_rsyslog_package_name = undef
          $_os_family_gnutls_package_name  = undef

          case $::operatingsystemmajrelease {
            '6': {
              $_version_os_family_manage_repo          = undef
              $_version_os_family_repo_data            = undef
              $_version_os_family_relp_package_name    = undef
              $_version_os_family_rsyslog_package_name = undef
              $_version_os_family_gnutls_package_name  = undef
            }
            '7': {
              $_version_os_family_manage_repo          = undef
              $_version_os_family_repo_data            = undef
              $_version_os_family_relp_package_name    = undef
              $_version_os_family_rsyslog_package_name = undef
              $_version_os_family_gnutls_package_name  = false
            }
            '8': {
              $_version_os_family_manage_repo          = false
              $_version_os_family_repo_data            = {}
              $_version_os_family_relp_package_name    = undef
              $_version_os_family_rsyslog_package_name = undef
              $_version_os_family_gnutls_package_name  = undef
            }
            default: {
              fail("Unsupported operatingsystemmajrelease (${::operatingsystem}) ${::operatingsystemmajrelease}")
            }
          }
        }
        'Ubuntu': {
          $_os_family_manage_repo          = true
          $_os_family_repo_data            = {
            'location' => 'http://ppa.launchpad.net/adiscon/v8-stable/ubuntu',
            'release'  => $::lsbdistcodename,
            'key'      => 'AB1C1EF6EDB5746803FE13E00F6DD8135234BF2B',
            'include'  => { 'source' => false },
            'repos'    => 'main',
            'pin'      => 1001,
          }
          $_os_family_relp_package_name    = undef
          $_os_family_rsyslog_package_name = undef
          $_os_family_gnutls_package_name  = undef

          case $::operatingsystemmajrelease {
            '14.04': {
              $_version_os_family_manage_repo          = undef
              $_version_os_family_repo_data            = undef
              $_version_os_family_relp_package_name    = undef
              $_version_os_family_rsyslog_package_name = undef
              $_version_os_family_gnutls_package_name  = undef
            }
            '15.04', '15.10': {
              $_version_os_family_manage_repo          = undef
              $_version_os_family_repo_data            = undef
              $_version_os_family_relp_package_name    = undef
              $_version_os_family_rsyslog_package_name = undef
              $_version_os_family_gnutls_package_name  = false
            }
            default: {
              fail("Unsupported operatingsystemmajrelease (${::operatingsystem}) ${::operatingsystemmajrelease}")
            }
          }
        }
        default: {
          fail("Unsupported operatingsystem ${::operatingsystem}")
        }
      }
    }
    'redhat': {
      $_family_manage_repo          = undef
      $_family_repo_data            = undef
      $_family_relp_package_name    = undef
      $_family_rsyslog_package_name = undef
      $_family_gnutls_package_name  = undef

      case $::operatingsystem {
        'Redhat', 'CentOS': {
          $_os_family_manage_repo          = true
          $_os_family_repo_data            = {
            'baseurl'        => "http://rpms.adiscon.com/v8-stable/epel-${::operatingsystemmajrelease}/\$basearch",
            'failovermethod' => 'priority',
            'priority'       => '99',
            'enabled'        => '1',
            'gpgcheck'       => '0',
            #'gpgkey'        => '',
          }
          $_os_family_relp_package_name    = undef
          $_os_family_rsyslog_package_name = undef
          $_os_family_gnutls_package_name  = undef

          case $::operatingsystemmajrelease {
            '5', '6', '7': {
              $_version_os_family_manage_repo          = undef
              $_version_os_family_repo_data            = undef
              $_version_os_family_relp_package_name    = undef
              $_version_os_family_rsyslog_package_name = undef
              $_version_os_family_gnutls_package_name  = undef
            }
            default: {
              fail("Unsupported operatingsystemmajrelease (${::operatingsystem}) ${::operatingsystemmajrelease}")
            }
          }
        }
        default: {
          fail("Unsupported operatingsystem ${::operatingsystem}")
        }
      }
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }

  $manage_repo          = pick(
                            $::rsyslogv8::params::_version_os_family_manage_repo,
                            $::rsyslogv8::params::_os_family_manage_repo,
                            $::rsyslogv8::params::_family_manage_repo,
                            false
                          )
  $repo_data            = pick(
                            $::rsyslogv8::params::_version_os_family_repo_data,
                            $::rsyslogv8::params::_os_family_repo_data,
                            $::rsyslogv8::params::_family_repo_data,
                            {}
                          )
  $rsyslog_package_name = pick(
                            $::rsyslogv8::params::_version_os_family_rsyslog_package_name,
                            $::rsyslogv8::params::_os_family_rsyslog_package_name,
                            $::rsyslogv8::params::_family_rsyslog_package_name,
                            'rsyslog'
                          )
  $gnutls_package_name  = pick(
                            $::rsyslogv8::params::_version_os_family_gnutls_package_name,
                            $::rsyslogv8::params::_os_family_gnutls_package_name,
                            $::rsyslogv8::params::_family_gnutls_package_name,
                            'rsyslog-gnutls'
                          )
  $relp_package_name    = pick(
                            $::rsyslogv8::params::_version_os_family_relp_package_name,
                            $::rsyslogv8::params::_os_family_relp_package_name,
                            $::rsyslogv8::params::_family_relp_package_name,
                            'rsyslog-relp'
                          )
  $package_status       = 'latest'
}
