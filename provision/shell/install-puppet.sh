#!/bin/bash

PUPPET_DIR='/vagrant/provision/puppet/development'

# Install Puppet Agent, Librarian Puppet (modules manager) and Puppet modules.
if [[ ! -f /tmp/vagrant-puppet/install-puppet ]]; then
    echo 'Vagrant: installing Puppet, Librarian Puppet, and Puppet modules'
    wget -qO /etc/apt/trusted.gpg.d/puppet.gpg https://apt.puppetlabs.com/keyring.gpg
    echo 'deb https://apt.puppetlabs.com/ bookworm puppet8' > /etc/apt/sources.list.d/puppet.list
    apt-get -q update && apt-get -qy install puppet-agent librarian-puppet
    export PATH=/opt/puppetlabs/bin:$PATH
    # The line below fixes an issue related to Vagrant not able to copy facts
    # to this guest directory because it is not created when installing facter,
    # even with version > 3.14.12-1.
    # https://tickets.puppetlabs.com/browse/PA-1025
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=962692
    mkdir -p /etc/puppetlabs/facter/facts.d/
    # The line below fixes an issue related to Librarian Puppet not able to
    # install modules in a shared directory. There is no existing ticket on
    # https://tickets.puppetlabs.com/.
    mkdir /tmp/vagrant-puppet/librarian/ && librarian-puppet config tmp $_ --global
    touch /tmp/vagrant-puppet/install-puppet
    cd $PUPPET_DIR && librarian-puppet install #--verbose
    touch /tmp/vagrant-puppet/install-puppet-modules
    echo 'Vagrant: finished installing Puppet, Librarian Puppet, and Puppet modules'
fi

if [[ ! -f /tmp/vagrant-puppet/install-puppet-modules ]]; then
    echo 'Vagrant: updating Puppet modules'
    cd $PUPPET_DIR && librarian-puppet update
    touch /tmp/vagrant-puppet/install-puppet-modules
    echo 'Vagrant: finished updating Puppet modules'
fi
