# Server.pp
class cw_server (Array $packages = [], String $timezone) {

  # Update package list
  exec { 'update-package-list': command => '/usr/bin/apt-get -q update' }

  # Add a rule to update package list before installing packages
  Exec['update-package-list'] -> Package <| |>

  # Add backports (main component) packages repository
  file { '/etc/apt/sources.list.d/backports.list':
    content => 'deb http://httpredir.debian.org/debian buster-backports main',
    before  => Exec['update-package-list'],
  }
  file { '/etc/apt/preferences.d/backports.pref':
    content => "Package: *\nPin: release a=buster-backports\nPin-Priority: 500",
  }

  # Install packages from configuration
  ensure_packages($packages)

  # Configure time
  exec { 'set-timezone':
    command => "timedatectl set-timezone $timezone",
    unless  => "test `cat /etc/timezone` = $timezone",
    path    => '/usr/bin',
  }

  # Configure SWAP
  # Todo: remove petems/swap_file dependency
  include swap_file

  # Install and configure Mailhog
  class { 'mailhog': mailhog_version => '1.0.1' }

  # Copy user files
  exec { 'copy-user-files':
    command => 'cp -r /vagrant/provision/files/. /home/vagrant && chown vagrant:vagrant -R /home/vagrant',
    path    => '/usr/bin/',
  }
}
