require 'active_support/time'

$BASE_CONFIG = RecursiveOpenStruct.new YAML.load_file('config/config.yml')
$CONFIG = $BASE_CONFIG.app

Time.zone = $CONFIG.time_zone
