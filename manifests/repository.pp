class rsyslogv8::repository {
  case $::osfamily {
    'redhat': {
      $repotype = 'yumrepo'
    }
    'debian': {
      $repotype = 'apt::source'
    }
    default: {
      fail('Do not know what to do here, please add osfamily support')
    }
  }
  if $::rsyslogv8::pin_packages {
    case $::osfamily {
      'redhat': {
        fail('redhat pinning not supported')
      }
      'debian': {
        $pin_type = 'apt::pin'
      }
      default: {
        fail('unsupported family for pinning')
      }
    }
    create_resources($pin_type, {'rsyslogv8_packages' => $::rsyslogv8::pin_packages})
  }
  if $::rsyslogv8::manage_repo {
    create_resources($::rsyslogv8::repository::repotype, {'rsyslogv8_repo' => $::rsyslogv8::repo_data})
  }
}
