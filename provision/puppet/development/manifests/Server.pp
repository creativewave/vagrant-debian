# Server.pp
class cw_server (Array $packages = []) {

  # Update packages list
  exec { 'update': command => 'apt-get -q update' }

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
  class { 'mailhog': mailhog_version => '1.0.1' }

  # Copy user dot files
  exec { 'dotfiles':
    command => 'cp -r /vagrant/provision/files/. /home/vagrant && chown vagrant:vagrant -R /home/vagrant',
    path    => '/usr/bin/',
  }
}
