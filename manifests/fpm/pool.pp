define php54::fpm::pool(
  $timezone = 'America/Denver'
) {
  require php54::config
  require homebrew::config

  file { "${php54::config::fpmpooldir}/${title}.conf":
    content => template('php54/fpm/pool.conf.erb')
  }
}
