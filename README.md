# Vagrant Debian

[Vagrant](https://www.vagrantup.com/) recipe for mounting a virtual machine with the [official Debian](https://app.vagrantup.com/debian/) in its [latest stable version](https://www.debian.org/releases/index.en.html), provided by [VirtualBox](https://www.virtualbox.org/) and provisioned with the following stack, installed from main components or backports of the official package repositories:

* Nginx
* NodeJS
* PHP FPM + Xdebug + Composer
* MariaDB
* Mailhog

## Hosts file

It you do not want to request and receive data by using a local domain, but only using an IP (default: `192.168.56.101`), you can skip this section.

To forward requests from a local domain (default: `local.test`) to the virtual machine IP, your `hosts` file should be modified:

* Windows: `C:\Windows\System32\drivers\etc\hosts`
* Mac and other Unix systems: `/etc/hosts`

Other domains such as `my-app-domain.test` or `dev.my-app-domain.com` can be appended to your `hosts`. A subdomain is recommended if you're planning to develop your app locally using https.

If you do not want to manually change your `hosts` for each new project, you can either:

* use different ports such as `local.test:8001`, `local.test:8002`, etc…
* use different folders such as `local.test/my-first-app/`, `local.test/my-second-app/`, etc…
* install [vagrant-hostmanager](https://github.com/devopsgroup-io/vagrant-hostmanager) and setup `Vagrantfile` accordingly

## Shared folder(s)

Some issues might occur when running `npm install` or `composer install` in a shared folder. The easiest workaround is to create a symlink (in the guest file system) from a non shared folder to the current shared folder:

With Composer, run `ln -s -T ~/composer/<my-app> vendor` from `/var/www/<my-app>/`.

With npm, run the following commands from `/var/www/<my-app>/`:

```shell
    ln -s ~/npm/<my-app>/node_modules
    cd ~/npm/<my-app>
    ln -s /path/to/<my-app>/package.json
    ln -s /path/to/<my-app>/package-lock.json
```

**Note:** if you have protocol errors when using `ln -s`, you should open your terminal (and run `vagrant up`) with admin privileges.

## Watching files

Some interfaces for watching files (eg. `fs.watch` in NodeJS) may require installing `vagrant-notify-forwarder`, because Virtual Box does not forward change events on host files to the guest. Polling (and diffing previous/current last modification time) is an alternative offered by some tools (eg. Webpack), that is fast enough when the number of watched files remains moderate.

## Todo

* Add settings in config.yaml to configure Nginx (with Augeas)
* Remove puppetlabs/mysql dependency
