
# Puppet Standard Library
include stdlib

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
