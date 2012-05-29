require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :development)

require File.expand_path('../../lib/init', __FILE__)

set :base, "#{ENV['HOME']}/#{$CONFIG.name}/current"
set :output, "#{base}/log/cron.log"

send(:every, eval($CONFIG.app.cron.frequency), eval("{ #{$CONFIG.app.cron.options} }")) do
  command "cd #{base} && ERRBIT_ENABLE=true APP_ENV=production ./scripts/new_dvds --verbose"
end