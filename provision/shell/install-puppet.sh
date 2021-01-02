#!/bin/bash

PUPPET_DIR='/vagrant/provision/puppet/development'

# Install Puppet Agent, Librarian Puppet (modules manager) and Puppet modules.
if [[ ! -f /.vagrant/install-puppet ]]; then
    echo 'Vagrant: installing Puppet, Librarian Puppet, and Puppet modules'
    apt-get -qq update && apt-get -qy install puppet librarian-puppet
    touch /.vagrant/install-puppet
    cd $PUPPET_DIR && librarian-puppet install
    touch /.vagrant/install-puppet-modules
    echo 'Vagrant: finished installing Puppet, Librarian Puppet, and Puppet modules'
fi

if [[ ! -f /.vagrant/install-puppet-modules ]]; then
    echo 'Vagrant: updating Puppet modules'
    cd $PUPPET_DIR && librarian-puppet update
    touch /.vagrant/install-puppet-modules
    echo 'Vagrant: finished updating Puppet modules'
fi
