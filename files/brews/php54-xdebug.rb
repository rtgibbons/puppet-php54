require File.join(File.dirname(__FILE__), 'abstract-php-extension')

class Php54Xdebug < AbstractPhp54Extension
  init
  homepage 'http://xdebug.org'
  url 'http://xdebug.org/files/xdebug-2.2.1.tgz'
  sha1 '8b4aec5f68f2193d07bf4839ee46ff547740ed7e'
  head 'https://github.com/derickr/xdebug.git'

  def extension_type; "zend_extension"; end

  def install
    Dir.chdir "xdebug-#{version}" unless build.head?

    ENV.universal_binary if build.universal?

    safe_phpize
    system "./configure", "--prefix=#{prefix}",
                          phpconfig,
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-xdebug"
    system "make"
    prefix.install "modules/xdebug.so"
    write_config_file unless build.include? "without-config-file"
  end
end
