require 'webspicy/cmd'

Webspicy::Configuration.new(Path.dir) do |c|
  c.factory = Webspicy::Cmd
end
