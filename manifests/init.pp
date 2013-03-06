class php54 {
  require php54::config
  require php54::pear
  require homebrew

  exec { 'tap-josegonzalez-php':
    command => 'brew tap josegonzalez/php',
    creates => "${homebrew::config::tapsdir}/josegonzalez-php",
    before  => Package['php54']
  }

  exec { 'tap-homebrew-dupes':
    command => 'brew tap homebrew/dupes',
    creates => "${homebrew::config::tapsdir}/homebrew-dupes",
    before  => Package['zlib']
  }

  package { 'zlib':
    ensure => present
  }

  package { 'php54':
    ensure          => present,
    install_options => [
      '--with-fpm',
      '--without-apache'
    ],
    require         => Package['zlib']
  }

  package { 'php54-apc':
    ensure  => present,
    require => Package['php54']
  }

  package { 'php54-mcrypt':
    ensure  => present,
    require => Package['php54']
  }

  package { 'php54-xdebug':
    ensure  => present,
    require => Package['php54']
  }

  file { [
    $php54::config::configdir,
    $php54::config::datadir,
    $php54::config::logdir,
    $php54::config::fpmpooldir,
    $php54::config::socketdir
    ]:
    ensure => directory
  }

  file { "${php54::config::homebrewconfigdir}/php.ini":
    content => template('php54/php.ini.erb'),
    notify  => Service['dev.php-fpm'],
    require => Package['php54']
  }

  file { "${php54::config::homebrewconfigdir}/php-fpm.conf":
    content => template('php54/php-fpm.conf.erb'),
    notify  => Service['dev.php-fpm'],
    require => Package['php54']
  }

  file { $php54::config::configfile:
    ensure  => link,
    target  => "${php54::config::homebrewconfigdir}/php.ini",
    require => File["${php54::config::homebrewconfigdir}/php.ini"]
  }

  php54::fpm::pool { 'php-fpm-general-pool': }

  file { $php54::config::fpmconfigfile:
    ensure  => link,
    target  => "${php54::config::homebrewconfigdir}/php-fpm.conf",
    require => File["${php54::config::homebrewconfigdir}/php-fpm.conf"]
  }

  file { '/Library/LaunchDaemons/dev.php-fpm.plist':
    content => template('php54/dev.php-fpm.plist.erb'),
    group   => 'wheel',
    notify  => Service['dev.php-fpm'],
    owner   => 'root'
  }

  service { 'dev.php-fpm':
    ensure  => running,
    require => Package['php54']
  }
}
