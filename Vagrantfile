
require 'yaml'

conf = YAML.load_file('config.yaml')

Vagrant.configure('2') do |config|

  # Machine
  # https://www.vagrantup.com/docs/vagrantfile/machine_settings.html
  config.vm.box      = conf['vm']['box']
  config.vm.hostname = conf['vm']['hostname']

  # SSH
  # https://www.vagrantup.com/docs/vagrantfile/ssh_settings.html
  config.ssh.insert_key = false

  # Network
  # https://www.vagrantup.com/docs/networking/
  config.vm.network 'private_network', ip: conf['vm']['ip']

  # Synced folders
  # https://www.vagrantup.com/docs/synced-folders/
  config.vm.synced_folder conf['vm']['shared']['source'], conf['vm']['shared']['target'],
    id:    'var/www',
    type:  'virtualbox',
    group: 'vagrant', # NodeJS will be run as this user.
    owner: 'www-data',
    mount_options: ['dmode=775', 'fmode=774']

  # Provider (Virtual Box)
  # https://www.vagrantup.com/docs/virtualbox/configuration.html
  config.vm.provider 'virtualbox' do |vb|
    vb.name   = conf['vm']['name']
    vb.cpus   = conf['vm']['cpus']
    vb.memory = conf['vm']['memory']
    # Allow guest to use host DNS in order to speed up domain names resolutions.
    # https://www.virtualbox.org/manual/ch09.html#nat_host_resolver_proxy
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    # VirtualBox prevents service `systemd-timesyncd` to start, as it already
    # handles time sync (based on host time), but related settings are not low
    # enough in order to keep it synced when VM is up since a long time.
    # http://www.virtualbox.org/manual/ch09.html#changetimesync
    vb.customize ['guestproperty', 'set', :id, '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', '6000']
    # Following statements are related to an issue regarding symlinks.
    # See https://www.virtualbox.org/manual/ch04.html#sharedfolders
    # But it's not enough to enable this privilege. Run Vagrant as admin or
    # see https://www.virtualbox.org/ticket/10085#comment:32
    vb.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate//vagrant', '1']
    vb.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate//var/www', '1']
  end

  # Provisioning
  # https://www.vagrantup.com/docs/provisioning/
  # Create a directory managing provisioning tasks status.
  config.vm.provision :shell, inline: 'mkdir -p /.vagrant'
  # Hook before first vagrant up (executed once or use 'provision' flag/command).
  config.vm.provision :shell do |s|
    s.path = 'provision/shell/exec-hooks.sh'
    s.args = ['exec-preprovision']
  end
  # Puppet install and (main) provisionning (executed once or use 'provision' flag/command).
  # https://www.vagrantup.com/docs/provisioning/puppet_apply.html
  config.vm.provision :shell, path: 'provision/shell/install-puppet.sh'
  config.vm.provision :puppet do |puppet|
    puppet.environment        = 'development'
    puppet.environment_path   = 'provision/puppet'
    puppet.facter             = conf
    puppet.structured_facts   = true
    puppet.synced_folder_type = 'virtualbox'
    puppet.options            = '--verbose'
  end
  # Hook after first vagrant up (executed once or use 'provision' flag/command).
  config.vm.provision :shell do |s|
    s.path = 'provision/shell/exec-hooks.sh'
    s.args = ['exec-once', 'exec-always']
  end
  # Hook after first vagrant up (executed once or use 'provision' flag/command), without sudo privileges.
  config.vm.provision :shell, privileged: false do |s|
    s.path = 'provision/shell/exec-hooks.sh'
    s.args = ['exec-once-unprivileged', 'exec-always-unprivileged']
  end
  # Hook after each vagrant up/reload (executed once or use 'provision' flag/command).
  config.vm.provision :shell, run: 'always' do |s|
    s.path = 'provision/shell/exec-hooks.sh'
    s.args = ['startup-once', 'startup-always']
  end
  # Hook after each vagrant up/reload (executed once or use 'provision' flag/command), without sudo privileges.
  config.vm.provision :shell, run: 'always', privileged: false do |s|
    s.path = 'provision/shell/exec-hooks.sh'
    s.args = ['startup-once-unprivileged', 'startup-always-unprivileged']
  end

end
