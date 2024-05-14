
include stdlib

Exec { path => '/usr/bin/:/usr/sbin/' }
exec { 'apt-get -q update': } -> Package <| title != 'gnupg2' |>

class { 'server':
  packages => $server['packages'],
  timezone => $server['timezone'],
}
class { 'nginx':
  vhosts  => $nginx['vhosts'],
}
include nodejs
class { 'php':
  modules => $php['modules'],
  pool    => $php['pool'],
  conf    => $php['conf'],
  xdebug  => $php['xdebug'],
}
include mariadb
