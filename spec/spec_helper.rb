require 'bundler/setup'
require "rspec"

$:.unshift "lib"

Rspec.configure do |config|
  config.color_enabled = true
end