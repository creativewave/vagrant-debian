# Nginx.pp
class cw_nginx (
  Array $modules = [],
  Hash $vhosts = {}
) {

  # Todo: remove puppet/nginx dependency and configure Nginx with Augeas.
  # Todo: add some basic performances optimizations settings in config.yaml.

  # Install and configure Nginx.
  class { 'nginx':
    http2    => 'on',
    sendfile => 'off', # Not used... but required! https://www.vagrantup.com/docs/synced-folders/virtualbox.html#caveats
  }

  # Configure upstream 'php-fpm'.
  nginx::resource::upstream { 'php-fpm':
    members             => ['unix:/var/run/php/php7.3-fpm.sock'],
    upstream_cfg_append => { 'keepalive' => 32 },
  }

  # Configure virtual hosts.
  ensure_resources(nginx::resource::server, $vhosts)

  # Fix issue from puppet/nginx causing duplicate '_' (default) servers.
  file { '/etc/nginx/sites-enabled/default': ensure => absent }
}
