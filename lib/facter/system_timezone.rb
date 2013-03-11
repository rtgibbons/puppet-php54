require 'facter'

Facter.add("system_timezone") do
  setcode do
    Facter::Util::Resolution.exec('systemsetup -gettimezone').gsub("Time Zone: ", "")
  end
end