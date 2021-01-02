# Server.pp
class cw_server (Array $packages = []) {

  # Add a cron job to keep packages/archives clean and updated
  cron { 'cron-job':
    command => 'apt-get -qq update; apt-get -qq -y dist-upgrade; apt-get -qq autoremove --purge; apt-get -qq autoclean',
    hour    => 13,
    minute  => 0,
    user    => 'root',
  }

  # Update packages list
  exec { 'update': command => 'apt-get -qq update' }

  # Add a rule to update packages list before installing package
  Exec['update'] -> Package <| |>

  # Add backports (main component) packages repository
  file { '/etc/apt/sources.list.d/backports.list':
    content => 'deb http://httpredir.debian.org/debian buster-backports main',
    before  => Exec['update'],
  }
  file { '/etc/apt/preferences.d/backports.pref':
    content => "Package: *\nPin: release a=buster-backports\nPin-Priority: 500",
  }

  # Install packages from configuration
  ensure_packages($packages)

  # Configure time
  exec { 'timedatectl set-timezone Europe/Paris':
    unless => 'test `cat /etc/timezone` = Europe/Paris',
    path    => '/usr/bin',
  }

  # Configure SWAP
  # Todo: remove petems/swap_file dependency
  include swap_file

  # Install and configure Mailhog
  class { 'mailhog': mailhog_version => '1.0.0' }
  # Fix user permission issue: https://github.com/ftaeger/ftaeger-mailhog/issues/7
  exec { 'chmod g-w /usr/local && chmod g-w /usr/local/bin':
    onlyif => 'test 775 -eq `stat -c %a /usr/local | cut -c 2-`',
    notify => Service['mailhog'],
  }

  # Copy user dot files
  exec { 'dotfiles':
    cwd     => '/home/vagrant',
    command => 'cp -r /vagrant/provision/files/dot/.[a-zA-Z0-9]* /root/ && \
                cp -r /vagrant/provision/files/dot/.[a-zA-Z0-9]* /home/vagrant/ && \
                chown -R vagrant /home/vagrant/.[a-zA-Z0-9]*',
    path    => '/usr/bin/',
  }
}
