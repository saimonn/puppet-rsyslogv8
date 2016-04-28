require 'spec_helper_acceptance'

describe 'rsyslogv8' do
  context 'ruleset with actions' do
    pp = <<-EOS
      class { 'rsyslogv8':
        modules_extras => { 'omrelp' => {} },
      }
      rsyslogv8::config::ruleset { 'test':
        actions => [
          {
            'type' => 'omfwd',
            'name' => 'send',
            'target' => 'localhost',
            'protocol' => 'tcp',
            'comment' => 'This is a one-line comment',
            'queue' => {
              'type' => 'LinkedList',
            },
          },
          { 'type' => 'omfwd',
            'target' => 'localhost',
            'protocol' => 'udp',
            'name'     => 'send2',
            'queue'    => {
              'type'     => 'Disk',
              'filename' => 'queue-filename2',
            },
          },
          {
            'type'     => 'omfwd',
            'protocol' => 'tcp',
            'target'   => 'localhost',
            'name'     => 'send3',
            'ssl'      => true,
            'queue'    => {
              'type' => 'FixedArray',
            },
          },
          {
            'type'             => 'omfwd',
            'protocol'         => 'tcp',
            'target'           => 'localhost',
            'name'             => 'send4',
            'ssl'              => true,
            'auth'             => 'x509/name',
            'selector'         => 'local0.*',
            'authorised_peers' => 'localhost',
            'queue'            => {
              'type'             => 'LinkedList',
              'filename'         => 'queue-filename',
              'max_disk_space'   => '4g',
              'save_on_shutdown' => true,
            },
          },
          {
            'type'    => 'omrelp',
            'name'    => 'send10',
            'target'  => 'localhost',
            'comment' => 'This is a one-line comment',
          },
          {
            'type'   => 'omrelp',
            'target' => 'localhost',
            'name'   => 'send11',
            'ssl'    => true,
          },
          {
            'type'             => 'omrelp',
            'target'           => 'localhost',
            'name'             => 'send12',
            'ssl'              => true,
            'auth'             => 'x509/name',
            'selector'         => 'local0.*',
            'authorised_peers' => 'localhost',
          },
          {
            'name'     => 'local1',
            'type'     => 'omfile',
            'file'     => 'localhost',
            'template' => 'RSYSLOG_TraditionalFileFormat',
          },
          {
            'name'     => 'local2',
            'type'     => 'omfile',
            'file'     => 'localhost2',
            'selector' => '&',
          },
          {
            'type'     => 'stop',
            'name'     => 'stop',
            'selector' => '*.*',
          },
        ]
      }
    EOS
    it 'should apply without error' do
      apply_manifest(pp, :catch_failures => true)
    end
    it 'should idempotently run' do
      apply_manifest(pp, :catch_changes => true)
    end
    describe command('rsyslogd -N1') do
      its(:exit_status) { should eq 0 }
    end
  end
end
