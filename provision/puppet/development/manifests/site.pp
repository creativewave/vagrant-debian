
# Puppet Standard Library
include stdlib

# Set path (paths to all executable commands)
Exec { path => '/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/local/bin/:/usr/local/sbin/' }

# Configure services
$config = parseyaml(file('/vagrant/config.yaml'))
class { 'cw_server':
  packages => $config['server']['packages'],
}
class { 'cw_nginx':
  vhosts  => $config['nginx']['vhosts'],
}
include cw_nodejs
class { 'cw_php':
  modules => $config['php']['modules'],
  pool    => $config['php']['pool'],
  conf    => $config['php']['conf'],
  xdebug  => $config['php']['xdebug'],
}
include cw_mariadb
