
class mailhog {

  # Content of /etc/systemd/system/mailhog.service
  $service = @("SERVICE")
    [Unit]
    Description=Mailhog
    After=network.target
    [Install]
    WantedBy=multi-user.target
    [Service]
    User=mailhog
    ExecStart=/usr/local/bin/mailhog/mailhog -hostname ${vm['hostname']}
    StandardOutput=file:/var/log/mailhog.log
    | SERVICE

  file { '/usr/local/bin/mailhog': ensure => directory }

  exec { 'mailhog':
    command => 'wget -qO /usr/local/bin/mailhog/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64',
    creates => '/usr/local/bin/mailhog/mailhog',
  }
  file { '/usr/local/bin/mailhog/mailhog':
    ensure => 'present',
    mode   => '0755',
  }
  file { '/usr/bin/mailhog':
    ensure => link,
    target => '/usr/local/bin/mailhog/mailhog',
  }

  file { '/etc/systemd/system/mailhog.service': content => $service }

  user { 'mailhog':
    home   => '/usr/local/bin/mailhog',
    system => true,
  }

  service { 'mailhog': ensure  => 'running' }
}
