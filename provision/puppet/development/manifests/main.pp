
# Puppet Standard Library
include stdlib

# Set path (paths to all executable commands)
Exec { path => '/bin/:/sbin/:/usr/bin/:/usr/sbin/:/usr/local/bin/:/usr/local/sbin/' }

# Configure services
class { 'cw_server':
  packages => $server['packages'],
}
class { 'cw_nginx':
  vhosts  => $nginx['vhosts'],
}
include cw_nodejs
class { 'cw_php':
  modules => $php['modules'],
  pool    => $php['pool'],
  conf    => $php['conf'],
  xdebug  => $php['xdebug'],
}
include cw_mariadb
