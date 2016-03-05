class Location
	attr_reader :name, :tz

  CITY_NAMES = ["Chicago", "San Francisco", "New York", "Columbus", "San Diego"]
  LOCATION_NAMES = CITY_NAMES + ["Remote"]

  def initialize(name, tz=nil)
    @name, @tz = name, tz
  end

  def physical?
    CITY_NAMES.include? name
  end

  def slug
    self.name.downcase.parameterize
  end

  def self.slug_to_name(slug)
    slug.gsub('-',' ').titleize
  end

  def self.all
    @@dbc_locations ||= [
      Location.new("Chicago", "Central Time (US & Canada)"),
      Location.new("San Francisco", "Pacific Time (US & Canada)"),
      Location.new("New York", "Eastern Time (US & Canada)"),
      Location.new("Columbus", "Eastern Time (US & Canada)"),
      Location.new("San Diego", "Pacific Time (US & Canada)"),
      Location.new("Remote")
    ]
  end

  def self.find_by_name(name)
    self.all.find {|c| c.name == name}
  end

  def self.find_by_slug(slug)
    self.all.find {|c| c.slug == slug}
  end
end
