define php54::fpm::pool(
  $timezone = 'America/Denver'
) {
  require boxen::config
  
  file { "${boxen::config::configdir}/php-fpm.d/${title}.conf":
    content => template('php54/fpm/pool.conf.erb')
  }
}