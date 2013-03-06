# Template Puppet Module for Boxen

An example of how we write Puppet modules for Boxen. Replace this
paragraph with a short explanation of what the heck makes your module
useful.

This module also installs PEAR from a package manager and aids you in installing
the latest versions (or specified versions) of PEAR packages.

## Usage: 

```
include php54
```

### PEAR Usage:

This module will try to install PEAR via the package name `php-pear` (this is
also configurable) and will then allow the installation of PEAR packages
through the pear::package function.

Here is an example of installing the default `php-pear` package and upgrading
PEAR, then installing Console_Table and finally installing drush 4.5.0 from a
third-party PEAR repository, pear.drush.org.

#### Version numbers are supported.

```
php54::pear { "drush":
  version => "4.5.0",
  repository => "pear.drush.org",
}
```

#### If no version number is supplied, the latest stable release will be installed. In this case, upgrade PEAR to 1.9.2+ so it can use pear.drush.org without complaint.

```
php54::pear { "PEAR": }
php54::pear { "Console_Table": }
```

#### Version numbers are supported.  Also, make sure PEAR is upgraded before trying to install drush.

```
php54::pear { "drush":
  version => "4.5.0",
  repository => "pear.drush.org",
  require => Pear::Package["PEAR"],
}
```


## Required Puppet Modules

* `boxen`
* `anything-else`

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.

## Credit

This code is taken from https://gist.github.com/305778, which is itself based on
http://www.mit.edu/~marthag/puppet/pear.rb.

You can see all the changes that have been made since the initial commit at the
following URL:

https://github.com/smerrill/puppet-pear/commits/master/lib/puppet/provider/package/pear.rb





