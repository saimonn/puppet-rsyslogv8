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
  if $::rsyslogv8::manage_repo {
    create_resources($::rsyslogv8::repository::repotype, {'rsyslogv8_repo' => $::rsyslogv8::repo_data})
  }
}
