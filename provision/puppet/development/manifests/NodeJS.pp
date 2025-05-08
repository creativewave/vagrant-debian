
class nodejs {

  exec { 'nodejs-gnupg-key':
    command => 'wget -qO - https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodejs.gpg',
    creates => '/usr/share/keyrings/nodejs.gpg',
  }

  # Note: https (official url scheme) requires apt-transport-https
  file { '/etc/apt/sources.list.d/nodejs.list':
    content => 'deb [signed-by=/usr/share/keyrings/nodejs.gpg] http://deb.nodesource.com/node_24.x/ nodistro main',
    before  => Exec['apt-get -q update'],
  }
  package { 'nodejs': }
}
