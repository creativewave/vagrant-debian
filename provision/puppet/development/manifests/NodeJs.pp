# NodeJS.pp
class cw_nodejs {

  # Install NodeJS.
  exec { 'nodejs':
    command => 'curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - \
                && sudo apt-get install -y nodejs',
    onlyif  => 'test ! -f /usr/bin/node',
  }
}
