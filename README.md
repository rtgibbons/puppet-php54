# Template Puppet Module for Boxen

This modules installs PHP 5.4 in the Boxen/Puppet environment. I have a mac. I have not tested this on anything other than a mac and Mountain Lion Mac OS 10.8.

## Usage: 

```
include php54
```

### PEAR Usage:

By default, pear is install with the PHP54 package. The PEAR class, however is an old version. Here is an example of upgrading
PEAR, then installing Console_Table and finally installing drush 4.5.0 from a
third-party PEAR repository, pear.drush.org.

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
}
```

To install the latest recommended version, simply leave off the version number.

## Required Puppet Modules

* `boxen`
* `anything-else`

## Development

Write code. Run `script/build` from the Boxen repo to test it. Check the `script`
directory for other useful tools.

## Credit

This code is taken from https://gist.github.com/305778, which is itself based on
http://www.mit.edu/~marthag/puppet/pear.rb.

You can see all the changes that have been made since the initial commit at the
following URL:

https://github.com/smerrill/puppet-pear/commits/master/lib/puppet/provider/package/pear.rb





