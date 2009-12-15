class OpenidProviders
  PROVIDERS = [
     "http://openid.aol.com/:username",
     "http://:username.myopenid.com",
     "http://:username.livejournal.com",
     "http://flickr.com/photos/:username",
     "http://technorati.com/people/technorati/:username",
     "http://:username.wordpress.com",
     "http://:username.blogspot.com",
     "http://:username.pip.verisignlabs.com",
     "http://:username.myvidoop.com",
     "http://:username.pip.verisignlabs.com",
     "http://claimid.com/:username"
  ]

  MATCHERS = PROVIDERS.collect do |provider|
    parts = provider.split(":username")
    Regexp.new(Regexp.escape(parts[0]) + '(.*)' + Regexp.escape(parts[1] || ""))
  end

  def self.extract_username(url)
    MATCHERS.collect {|rx| url[rx, 1]}.compact.first
  end
end