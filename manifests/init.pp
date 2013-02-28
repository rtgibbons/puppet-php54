class php54 {
  require homebrew

  exec { 'tap-josegonzalez-php':
    command => "brew tap josegonzalez/php",
    creates => "${homebrew::config::tapsdir}/josegonzalez-php",
    before  => Package['php54']
  }

  exec { 'tap-homebrew-dupes':
    command => "brew tap homebrew/dupes",
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

  package { 'php54-imagick': 
    ensure  => present,
    require => Package['php54']
  }

  package { 'php54-xdebug':
    ensure  => present,
    require => Package['php54']
  }


  package { 'php'}

}