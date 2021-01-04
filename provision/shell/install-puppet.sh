#!/bin/bash

PUPPET_DIR='/vagrant/provision/puppet/development'

# Install Puppet Agent, Librarian Puppet (modules manager) and Puppet modules.
if [[ ! -f /.vagrant/install-puppet ]]; then
    echo 'Vagrant: installing Puppet, Librarian Puppet, and Puppet modules'
    apt-get -q update && apt-get -qy install puppet librarian-puppet
    # The line below fixes an issue related to Vagrant not being able to copy
    # facts from host to the below guest directory that is not created when
    # installing facter < 3.14.12-1.
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=962692#50
    # https://tickets.puppetlabs.com/browse/PA-1025
    mkdir -p /etc/puppetlabs/facter/facts.d/
    # The line below fixes an issue related to Puppet not being able to install
    # modules in a shared directory.
    # No existing ticket on https://tickets.puppetlabs.com/.
    mkdir /tmp/vagrant-puppet/librarian/ && librarian-puppet config tmp $_ --global
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
