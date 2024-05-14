
class mariadb {

  # Install and run MariaDB server
  # TODO: remove puppetlabs/mysql dependency
  #package { 'mariadb-server': }
  #service { 'mariadb-server': hasrestart => true }
  class { 'mysql::server':
    restart => true,
    users   => {
      'vagrant@localhost' => {
        password_hash => '*04E6E1273D1783DF7D57DC5479FE01CFFDFD0058', # == vagrant
      },
    },
    grants => {
      'vagrant@localhost/*.*' => {
        options    => ['GRANT'],
        privileges => ['ALL'],
        table      => '*.*',
        user       => 'vagrant@localhost',
      },
    },
    # https://github.com/puppetlabs/puppetlabs-mysql/issues/1566
    override_options => {
      mysqld => { log-error => undef },
      mysqld_safe => { log-error => undef },
    },
  }

  # Install MariaDB client
  package { 'mariadb-client': }
}
