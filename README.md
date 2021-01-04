# Vagrant Debian

[Vagrant](https://www.vagrantup.com/) recipe to mount an [official Debian](https://app.vagrantup.com/debian/) server with the following stack, installed from backports main or official package repositories:

* Nginx
* NodeJS
* PHP FPM + Xdebug + Composer
* MariaDB
* Mailhog

## Hosts file

Your `hosts` file should be modified to forward requests from a specific domain (default: `local.test`) to the server IP (default: `192.168.56.101`). This file is located in:

* Windows: `C:\Windows\System32\drivers\etc\hosts`
* Mac and other Unix systems: `/etc/hosts`

Other domains such as `my-app-domain.test` or `dev.my-app-domain.com` can be appended to your `hosts`. A subdomain is recommended if you're planning to develop your app locally using https.

If you don't want to change your `hosts` for each new project, you can either:

* use different ports such as `local.test:8001`, `local.test:8002`, etc…
* use different folders such as `local.test/my-first-app/`, `local.test/my-second-app/`, etc…
* install [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager) and setup `Vagrantfile` to automatically add domains configured in `config.yml` as aliases of `local.test`

## Shared folder(s)

The [offical Vagrant Debian box](https://wiki.debian.org/Teams/Cloud/VagrantBaseBoxes#Shared_folders) uses `rsync` as the default type for its file system, which is not natively available on Windows. Other file systems are natively available: `virtualbox`, `nfs` (Mac and Linux), `smb` (Windows).

They all have different pros and cons but IMO `virtualbox` is the easiest one to use.

To use shared folders handled by `virtualbox` (vboxsf), you should either replace `debian/<release>` by `debian/contrib-<release>` in `config.yml`, or follow these 3 steps before running the first `vagrant up`:

1. run `vagrant plugin install vagrant-vbguest`
2. run `vagrant box add debian/<release>`
3. replace `rsync` by `virtualbox` in `~/.vagrant.d/boxes/debian-VAGRANTSLASH-<release>/<version>/virtualbox/Vagrantfile`

Some issues might appear when running `npm install` or `composer install` in a shared folders. The simpliest way to avoid these issues is to create a symlink to a non shared folder (eg. the `vagrant` user directory):

With Composer, just run `ln -s -T ~/composer/<my-app> vendor` from `/var/www/<my-app>/`.

With npm, run the following commands from `/var/www/<my-app>/`:

```shell
    ln -s ~/npm/<my-app>/node_modules
    cd ~/npm/<my-app>
    ln -s /path/to/<my-app>/package.json
    ln -s /path/to/<my-app>/package-lock.json
```

**Note:** if you have protocol errors when using `ln -s`, you should open your terminal (and run `vagrant up`) with admin privileges.

## Watching files

Some interfaces for watching files (eg. `fs.watch` in NodeJS) may require installing `vagrant-notify-forwarder`, because Virtual Box doesn't forward change events on host files to the guest. Some tools (eg. Webpack) offer an alternative via polling (and diffing previous/current last modification time), which is fast enough when the number of watched files stays moderate.

## Debugging a NodeJS script

To inspect a NodeJS script with a debugger like the Chrome Dev Tools, add `local.test:9222` as a network target in `chrome://inspect/#devices`, then connect via ssh to the Debian server with `vagrant ssh -- -L 9222:local.test:9222`, and run `node --inspect=0.0.0.0:9222 <script>.js`.

## Todo

* Add settings in config.yaml to configure Nginx (with Augeas)
* Remove puppetlabs/mysql dependency
* Remove petems/swap_file dependency
