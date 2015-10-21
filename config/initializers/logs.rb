location_logfile = File.open("#{ Rails.root }/log/location.log", 'a')
location_logfile.sync = true
$location_logger = LocationLogger.new(location_logfile)