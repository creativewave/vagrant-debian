# Vagrant Debian Stretch (Puppet)

Recipe for creating a development environment based on Debian Stretch with [Vagrant](https://www.vagrantup.com/) and [Puppet](https://docs.puppet.com/puppet/latest/), inspired by [Puphpet](https://puphpet.com/#custom-files).

## Stack

All packages are downloaded from main/backports official sources.

* Nginx
* PHP 7 FPM/CLI + Xdebug + Composer
* MariaDB
* NodeJS
* Mailhog

## Todo

* Remove puppetlabs/mysql dependency
* Remove puppet/nginx dependency and its soft dependency to puppetlabs/apt
* Configure Nginx with Augeas and add global performance settings in config.yaml
* Remove petems/swap_file dependency
* Remove willdurand/composer dependency and use official install script
