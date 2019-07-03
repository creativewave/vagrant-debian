# Vagrant Debian Stretch (Puppet)

Recipe to create and manage a Debian Stretch server with [Vagrant](https://www.vagrantup.com/) and [Puppet](https://docs.puppet.com/puppet/latest/), with the following stack:

* Nginx
* PHP FPM + Xdebug + Composer
* MariaDB
* NodeJS
* Mailhog

All packages are downloaded from main/backports official sources, and the OS version comes from the official Vagrant box for Debian: https://app.vagrantup.com/debian/.

Inspired from [Puphpet](https://puphpet.com/).

## Installation

`git clone https://github.com/creativewave/debian-stretch-vagrant vagrant/debian-stretch && cd $_ && vagrant up`

### Hosts file

The `hosts` file should be slightly modified in order to forwarded requests from a specific domain (eg: `local.test`) to the guest server IP (`192.168.56.101` by default).

On Windows, this file is located at `C:\Windows\System32\drivers\etc\hosts`.
On Mac and other Unix systems, this file is located at `/etc/hosts`.

Other domains such as `my-app.test` or `dev.my-app.com`, the latter being more flexible when using https, could be appended to `hosts`. If you don't want to change your `hosts` for every new project, you could either:

- use different ports such as `local.test:8001`, `local.test:8002`, etc…
- use different folders such as `local.test/my-first-app/`, `local.test/my-second-app/`, etc…
- install [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager) and slightly change the `Vagrantfile` to automatically set domains configured in `config.yml` as aliases for `local.test`

### Shared folder(s)

The [offical Vagrant Debian boxes](https://wiki.debian.org/Teams/Cloud/VagrantBaseBoxes#Shared_folders) are using `rsync` as the default type for its file system, but it is not available natively on Windows. Other file systems are natively available: `nfs` is available on Mac and Linux, `smb` is available on Windows. And there's also `virtualbox`.

They all have different pros and cons but IMO `virtualbox` is the easiest one to use.

To configure a shared folder handled by Virtual Box, you should do these 3 steps :

- `vagrant plugin install vagrant-vbguest`
- `vagrant box add debian/stretch64`
- replace `rsync` by `virtualbox` in `~/.vagrant.d/boxes/debian-VAGRANTSLASH-stretch64/<version>/virtualbox/Vagrantfile`

Run `vagrant up` and it works!

### Watching files

Interfaces to watch files like NodeJS `fs.watch` may require installing `vagrant-notify-forwarder`, because Virtual Box doesn't forward change events on host files to the guest. Some tools like Webpack may offer an alternative by using a polling strategy (and diffing previous/current last modification time), which is fast enough when the number of watched files stays moderate.

### NodeJS and npm

Running `npm install` inside shared folders may cause some issues related to symlinks. The simpliest way to avoid them is to create a symlink to a non shared folder inside the guest filesystem:

```
    mkdir -p ~/.<my-app>/node_modules && ln -s $_ && cd $_
    ln -s /path/to/<my-app>/package.json
    ln -s /path/to/<my-app>/package-lock.json
```

Note: if you have protocol errors with `ln`, you must run your terminal (and `vagrant up`) with admin privileges on your OS. If you `vagrant up` without admin privilege, exit terminal, then `vagrant ssh` with admin privilege, it will not work: you have to `vagrant reload` with admin privilege.

To inspect a NodeJS script with a debugger like Chrome Dev Tools, add `local.test:9222` as a network target in `chrome://inspect/#devices`, then run `node --inspect=0.0.0.0:9222 <myapp>.js`.

## Todo

* Remove puppetlabs/mysql dependency
* Remove puppet/nginx dependency and its soft dependency to puppetlabs/apt
* Configure Nginx with Augeas and add global performance settings in config.yaml
* Remove petems/swap_file dependency
* Remove willdurand/composer dependency and use official install script
