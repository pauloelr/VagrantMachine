VagrantMachine
==============

Ubuntu Precise 64 Vagrant Machine with Puppet Provisioning (LAMP + PhpMyAdmin + Pear + Composer + PHPUnit + Other Stuff)

For development porpuse only, DO NOT use it in production

Webserver access: http://192.168.2.2

PhpMyAdmin access: http://192.168.2.2/phpmyadmin   
phpMyAdmin user: root   
phpMyAdmin password: vagrant

If you need any other password it's probably ```vagrant```

Inspired on PuPHPet (https://puphpet.com/) but highly changed

Installation
------------

clone this repository recursively:

```Shell
git clone https://github.com/pauloelr/VagrantMachine.git --recursive
```

get inside the repository directory and run:

```Shell
vagrant up
``` 

Task List
---------

- [ ] Change MySQL Module to Submodule (Waiting PuppetLabs Launch Version 2.0.0)
- [ ] Change Concat Module to Submodule (Found some Bugs on Master Branch)
- [ ] Change PhpMyAdmin to Submodule (Considering change to https://github.com/justicel/puppet-phpmyadmin)

