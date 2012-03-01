require 'rubygems'
require 'rack'
require 'better_opener/server'

map "/notifications" do
  run BetterOpener::Server
end

