
class server (Array $packages = [], String $timezone) {

  stdlib::ensure_packages($server['packages'])

  exec { 'set-timezone':
    command => "timedatectl set-timezone ${server['timezone']}",
    unless  => "test `cat /etc/server['timezone']` = ${timezone}",
  }

  exec { 'copy-user-files':
    command => 'cp -r /vagrant/provision/files/. /home/vagrant && chown vagrant:vagrant -R /home/vagrant',
  }

  # Configure SWAP
  # Todo: remove petems/swap_file dependency
  include swap_file

  # Install and configure Mailhog
  class { 'mailhog': mailhog_version => '1.0.1' }
}
