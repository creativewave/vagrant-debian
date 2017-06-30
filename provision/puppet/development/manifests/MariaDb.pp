# MariaDB.pp
class cw_mariadb {

  # Install and run MariaDB server.
  # Todo: remove puppetlabs/mysql dependency
  # (Find out how to create a database user and grant him privileges)
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
  }

  # Install MariaDB client.
  package { 'mariadb-client': }
}
