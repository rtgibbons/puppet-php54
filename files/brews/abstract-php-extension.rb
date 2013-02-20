require 'formula'

class UnsupportedPhpApiError < RuntimeError
  attr :name

  def initialize name
    @name = name
    super "Unsupported PHP API Version"
  end
end

class InvalidPhpizeError < RuntimeError
  attr :name

  def initialize (installed_php_version, required_php_version)
    @name = name
    super <<-EOS.undent
      Version of phpize (PHP#{installed_php_version}) in $PATH does not support building this extension
             version (PHP#{required_php_version}). Consider installing  with the `--without-homebrew-php` flag.
    EOS
  end
end

class AbstractPhpExtension < Formula
  def initialize name='__UNKNOWN__', path=nil
    begin
      raise "One does not simply install an AbstractPhpExtension" if name == "abstract-php-extension"
      sup = super

      if build.include? 'without-homebrew-php'
        installed_php_version = nil
        i = IO.popen("#{phpize} -v")
        out = i.readlines.join("")
        i.close
        { 53 => 20090626, 54 => 20100412 }.each do |v, api|
          installed_php_version = v.to_s if out.match(/#{api}/)
        end

        raise UnsupportedPhpApiError.new if installed_php_version.nil?

        required_php_version = php_branch.sub('.', '').to_s
        unless installed_php_version == required_php_version
          raise InvalidPhpizeError.new(installed_php_version, required_php_version)
        end
      end

      sup
    rescue Exception => e
      # Hack so that we pass all brew doctor tests
      reraise = e.backtrace.select { |l| l.match(/(doctor|cleanup|leaves|uses)\.rb/) }
      raise e if reraise.empty?
    end
  end

  def self.init
    depends_on 'autoconf' => :build

    option 'without-homebrew-php', "Ignore homebrew PHP and use default instead"
  end

  def php_branch
    matches = /^Php5([3-9]+)/.match(self.class.name)
    if matches
      "5." + matches[1]
    else
      raise "Unable to guess PHP branch for #{self.class.name}"
    end
  end

  def php_formula
    'php' + php_branch.sub('.', '')
  end

  def safe_phpize
    system phpize
  end

  def phpize
    if build.include? 'without-homebrew-php'
      "phpize"
    else
      "#{(Formula.factory php_formula).bin}/phpize"
    end
  end

  def phpini
    if build.include? 'without-homebrew-php'
      "php.ini presented by \"php --ini\""
    else
      "#{(Formula.factory php_formula).config_path}/php.ini"
    end
  end

  def phpconfig
    if build.include? 'without-homebrew-php'
      ""
    else
      "--with-php-config=#{(Formula.factory php_formula).bin}/php-config"
    end
  end

  def extension
    matches = /^Php5[3-9](.+)/.match(self.class.name)
    if matches
      matches[1].downcase
    else
      raise "Unable to guess PHP extension name for #{self.class.name}"
    end
  end

  def extension_type
    # extension or zend_extension
    "extension"
  end

  def module_path
    prefix / "#{extension}.so"
  end

  def config_file
    begin
      <<-EOS.undent
      [#{extension}]
      #{extension_type}="#{module_path}"
      EOS
    rescue Exception => e
      nil
    end
  end

  def caveats
    caveats = [ "To finish installing #{extension} for PHP #{php_branch}:" ]

    if build.include? "without-config-file"
      caveats << "  * Add the following line to #{phpini}:\n"
      caveats << config_file
    else
      caveats << "  * #{config_scandir_path}/#{config_filename} was created,"
      caveats << "    do not forget to remove it upon extension removal."
    end

    caveats << <<-EOS
  * Restart your webserver.
  * Write a PHP page that calls "phpinfo();"
  * Load it in a browser and look for the info on the #{extension} module.
  * If you see it, you have been successful!
EOS

    caveats.join("\n")
  end

  def config_path
    etc / "php" / php_branch
  end

  def config_scandir_path
    config_path / "conf.d"
  end

  def config_filename
    "ext-" + extension + ".ini"
  end

  def config_filepath
    config_scandir_path / config_filename
  end

  def write_config_file
    if config_filepath.file?
      inreplace config_filepath do |s|
        s.gsub!(/^(zend_)?extension=.+$/, "#{extension_type}=\"#{module_path}\"")
      end
    elsif config_file
      config_scandir_path.mkpath
      config_filepath.write(config_file)
    end
  end

  def options
    options = []
    options << ["--without-config-file", "Do not add #{config_filename} to #{config_scandir_path}"] if config_file
    options
  end
end

class AbstractPhp53Extension < AbstractPhpExtension
  def self.init
    super
    depends_on "php53" unless build.include?('without-homebrew-php')
  end
end

class AbstractPhp54Extension < AbstractPhpExtension
  def self.init
    super
    depends_on "php54" unless build.include?('without-homebrew-php')
  end
end
