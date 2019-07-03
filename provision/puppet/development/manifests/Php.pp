# Php.pp
class cw_php (
  Array $modules = [],
  Hash  $pool    = {},
  Hash  $conf    = {},
  Hash  $xdebug  = {}
) {

  # Install and run PHP-FPM
  package { 'php7.0-fpm': }
  service { 'php7.0-fpm': hasrestart => true }

  # Install modules
  ensure_packages($modules, { notify => Service['php7.0-fpm'] })

  # Configure PHP-FPM pools
  $pool.each |$pool_name, $conf| {
    $conf.each |$key, $value| {
      augeas { "pool/${key}: ${value}":
        lens    => 'PHP.lns',
        incl    => '/etc/php/7.0/fpm/pool.d/www.conf',
        changes => ["set ${pool_name}/${key} '${value}'"],
        notify  => Service['php7.0-fpm'],
      }
    }
  }

  # Configure PHP
  file { '/etc/php/7.0/fpm/conf.d/99-custom.ini': replace => no }
  $conf.each |$key, $value| {
    augeas { "custom/${key}: ${value}":
      lens    => 'PHP.lns',
      incl    => '/etc/php/7.0/fpm/conf.d/99-custom.ini',
      changes => ["set custom/${key} '${value}'"],
      notify  => Service['php7.0-fpm'],
    }
  }

  # Configure Xdebug
  $xdebug.each |$key, $value| {
    augeas { "xdebug/${key}: ${value}":
      lens    => 'PHP.lns',
      incl    => '/etc/php/7.0/fpm/conf.d/99-custom.ini',
      changes => ["set xdebug/${key} '${value}'"],
      notify  => Service['php7.0-fpm'],
    }
  }

  # Install Composer
  # Todo: remove willdurand/composer dependency and use official install script.
  # https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md
  include composer
}
