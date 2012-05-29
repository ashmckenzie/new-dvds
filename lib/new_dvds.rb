module NewDvds
  def self.notify
    Emailer.transmit(RottenTomatoes.new_dvd_releases)
  end
end