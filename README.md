# Vagrant Debian Stretch (Puppet)

Recipe to create and manage a Debian Stretch server with [Vagrant](https://www.vagrantup.com/) and [Puppet](https://docs.puppet.com/puppet/latest/), with the following stack:

* Nginx
* PHP FPM + Xdebug + Composer
* MariaDB
* NodeJS
* Mailhog

All packages are downloaded from main/backports official sources, and the OS version comes from the official Vagrant box for Debian: https://app.vagrantup.com/debian/.

Inspired from [Puphpet](https://puphpet.com/).

## Todo

* Remove puppetlabs/mysql dependency
* Remove puppet/nginx dependency and its soft dependency to puppetlabs/apt
* Configure Nginx with Augeas and add global performance settings in config.yaml
* Remove petems/swap_file dependency
* Remove willdurand/composer dependency and use official install script
