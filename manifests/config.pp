class php54::config {
  require boxen::config

  $configdir         = "${boxen::config::configdir}/php"
  $configfile        = "${configdir}/php.ini"
  $datadir           = "${boxen::config::datadir}/php-fpm"
  $executable        = "${boxen::config::homebrewdir}/sbin/php-fpm"
  $logdir            = "${boxen::config::logdir}/php-fpm"
  $pidfile           = "${datadir}/php-fpm.pid"
  $socketdir         = "${boxen::config::socketdir}/php-fpm"
  $homebrewconfigdir = "${boxen::config::homebrewdir}/etc/php/5.4"
  $fpmconfigfile     = "${configdir}/php-fpm.conf"
  $fpmpooldir        = "${boxen::config::configdir}/php-fpm.d"
}
