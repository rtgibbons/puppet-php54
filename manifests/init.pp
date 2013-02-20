class php54 {
  require homebrew

  homebrew::formula { 'php54':
    before => Package['boxen/brews/php54']
  }

  package { 'boxen/brews/php54':
    ensure => '5.4.11-boxen1'
  }

} 