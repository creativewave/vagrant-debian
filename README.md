# Vagrant Debian

[Vagrant](https://www.vagrantup.com/) recipe for mounting a virtual machine with the [official Debian](https://app.vagrantup.com/debian/) in its [latest stable version](https://www.debian.org/releases/index.en.html), provided by [VirtualBox](https://www.virtualbox.org/) and provisioned with the following stack, installed from main components or backports of the official package repositories:

* Nginx
* NodeJS
* PHP FPM + Xdebug + Composer
* MariaDB
* Mailhog

## Configuring `hosts`

It you do not want to request and receive data via a local domain (default: `local.test`) rather than the virtual machine IP (default: `192.168.56.101`), you can skip this section.

Your `hosts` file should include a mapping from the IP to the hostname of the virtual machine. This file is located:

* on Windows: `C:\Windows\System32\drivers\etc\hosts`
* on Mac and other Unix systems: `/etc/hosts`

You may want to append other domains such as `my-app-domain.test` or `dev.my-app-domain.com`. A subdomain is recommended to develop an app with `https`.

If you do not want to manually change your `hosts` for each new project, you can either:

* use different ports such as `local.test:8001`, `local.test:8002`, etc…
* use different folders such as `local.test/my-first-app/`, `local.test/my-second-app/`, etc…
* install [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager) and setup `Vagrantfile` accordingly

## Shared folder(s)

Some issues might occur when running `npm install` or `composer install` in a shared folder. The easiest workaround is to create a symlink to a non shared folder:

```shell
    cd /var/www/<my-app>

    # For Composer
    mkdir -p ~/composer/<my-app>
    ln -s -T ~/composer/<my-app> vendor

    # For npm
    mkdir -p ~/npm/<my-app>
    ln -s ~/npm/<my-app>/node_modules
    cd ~/npm/<my-app>
    ln -s /var/www/<my-app>/package{-lock}.json
```

**Note:** if you have protocol errors when using `ln -s`, open your terminal (and run `vagrant up`) with admin privileges.

## Watching files

You may need `vagrant-notify-forwarder` to watch files (eg. with `fs.watch` in NodeJS) because Virtual Box does not forward change events on host files to the guest.

Polling (and diffing previous/current last modification time) is an alternative that remains fast enough when the number of watched files remains moderate.

## Debugging a NodeJS script

To inspect a NodeJS script in Chrome Dev Tools, add `local.test:9222` as a network target in `chrome://inspect/#devices`. Port `9222` is automatically mapped between the host and virtual machines when connecting to the latter with `vagrant ssh`.

## Todo

* Add settings in config.yaml to configure Nginx
* Remove puppetlabs/mysql dependency
