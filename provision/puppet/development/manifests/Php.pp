
class php (
  Array $modules = [],
  Hash  $pool    = {},
  Hash  $conf    = {},
  Hash  $xdebug  = {}
) {

  package { 'php8.2-fpm': }
  service { 'php8.2-fpm': }
  stdlib::ensure_packages($modules, { notify => Service['php8.2-fpm'] })

  # Configure PHP-FPM pools
  $pool.each |$pool_name, $conf| {
    $conf.each |$key, $value| {
      augeas { "pool/${key}: ${value}":
        lens    => 'PHP.lns',
        incl    => '/etc/php/8.2/fpm/pool.d/www.conf',
        changes => ["set ${pool_name}/${key} '${value}'"],
        notify  => Service['php8.2-fpm'],
      }
    }
  }

  # Configure PHP
  file { '/etc/php/8.2/fpm/conf.d/99-custom.ini': replace => no }
  $conf.each |$key, $value| {
    augeas { "custom/${key}: ${value}":
      lens    => 'PHP.lns',
      incl    => '/etc/php/8.2/fpm/conf.d/99-custom.ini',
      changes => ["set custom/${key} '${value}'"],
      notify  => Service['php8.2-fpm'],
    }
  }

  # Configure Xdebug
  $xdebug.each |$key, $value| {
    augeas { "xdebug/${key}: ${value}":
      lens    => 'PHP.lns',
      incl    => '/etc/php/8.2/fpm/conf.d/99-custom.ini',
      changes => ["set xdebug/${key} '${value}'"],
      notify  => Service['php8.2-fpm'],
    }
  }

  # Install Composer
  exec { 'composer':
    command => 'wget -qO - https://raw.githubusercontent.com/composer/getcomposer.org/master/web/installer | sudo php -- --install-dir /usr/bin/ --filename composer',
    creates => '/user/bin/composer',
  }
}
