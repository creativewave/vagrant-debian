#!/bin/bash

# https://www.debian.org/releases/stretch/amd64/ch05s03.html.fr#installer-args
export DEBIAN_FRONTEND=noninteractive

PUPPET_DIR='/vagrant/provision/puppet/development'

# Install Puppet Agent, Librarian Puppet (modules manager) and Puppet modules.
if [[ ! -f /.vagrant/install-puppet ]]; then
    echo 'Vagrant: installing Puppet, Librarian Puppet, and Puppet modules'
    apt-get -qq update && apt-get -qq install puppet librarian-puppet
    touch /.vagrant/install-puppet
    cd $PUPPET_DIR && librarian-puppet install --clean
    touch /.vagrant/install-puppet-modules
    echo 'Vagrant: finished installing Puppet, Librarian Puppet, and Puppet modules'
fi

if [[ ! -f /.vagrant/install-puppet-modules ]]; then
    echo 'Vagrant: updating Puppet modules'
    cd $PUPPET_DIR && librarian-puppet update
    touch /.vagrant/install-puppet-modules
    echo 'Vagrant: finished updating Puppet modules'
fi
