require "crypto/bcrypt/password"

class User < Granite::Base
  @distances_on_roids = JSON::OnSteroids.new

  adapter pg
  table_name users

  primary id : Int64
  timestamps
  field distances : String
  field name : String
  field email : String
  field gender : String
  field preference : String
  field neurostatus : String
  field description : String
  field city : String
  field state : String
  field country : String
  field password : String
  field token : String
  field sent_time : Time
  field accepted : Bool

  has_many :image

  def self.create_with_bcrypt(name : String, mail : String, word : String)
    user = new(name: name, email: mail, password: word)
    return false unless user.valid?
    user.password = bcryptify(word)
    user.save
  end

  def self.bcryptify(word : String)
    Crypto::Bcrypt::Password.create(word).to_s
  end

  def profile_pic
    img = image.find_by(profile: true) || Image.new
    img.object_url
  end

  def name_string
    name.to_s.downcase
  end

  def email_string
    email.to_s.downcase
  end

  def sent_time?
    sent_time || 2.hours.ago
  end

  def user_matches
    User.all.select do |usr|
      usr.name_string == name_string ||
        usr.email_string == email_string
    end
  end

  def one_match_is_current?
    user_matches.one? && user_matches.first.id == self.id
  end

  def uniq?
    user_matches.none? || one_match_is_current?
  end

  def no_blanks?
    [name, email, password].none? { |prop| prop.to_s.blank? }
  end

  def passes_validation?
    no_blanks? && uniq?
  end

  def valid?
    return false unless passes_validation?
    super
  end

  def update_token
    update(token: Random::Secure.hex(10), sent_time: Time.now)
  end

  def clear_token
    update(token: nil, sent_time: nil)
  end

  def available_matches(distance)
    User.all.select do |user|
      preference_match?(user) &&
      distance_from(user) <= distance
    end.sort_by(&.distance_from(self))
  end

  def preference_match?(other : User)
    preferred?(other) && other.preferred?(self)
  end

  def preferred?(other : User)
    split_preferences.includes?(other.gender)
  end

  def distance_from(other : User)
    get_distance(other).to_s.to_i
  end

  def get_distance(other : User)
    set_distances
    current_distance = current_distance_from?(other)
    return current_distance if current_distance
    save_new_distance(other)
    current_distance_from?(other)
  end

  def set_distances
    empty_json = Hash(String, String | Int32).new.to_json
    @distances_on_roids = JSON.parse(distances || empty_json).on_steroids!
  end

  def save_new_distance(other : User)
    @distances_on_roids["#{other.id}"] = { "distance" => maps_distance_from(other), "location" => other.location }
    self.distances = @distances_on_roids.to_json
    save
  end

  def current_distance_from?(other : User)
    hsh = @distances_on_roids["#{other.id}"]? || Hash(String, String | Int32).new
    return false unless location_exists?(hsh, other)
    hsh["distance"]?
  end

  private def location_exists?(hsh, other : User)
    hsh["distance"]? && location_converted?(hsh["location"]?) == other.location
  end

  private def location_converted?(loc)
    loc.to_s.lchop?.to_s.rchop?
  end
  
  def location
    "#{city} #{state}"
  end

  def possible_location?
    !!(city && state)
  end

  def maps_distance_from(other : User)
    begin
      raise "" unless locations_from_both?(other)
      req = distance_api_get(other)
      req["rows"][0]["elements"][0]["distance"]["value"]
    rescue exception
      999999
    end
  end

  def locations_from_both?(other : User)
    possible_location? && other.possible_location?
  end

  private def distance_api_get(other : User)
    Halite.get(
      "https://maps.googleapis.com/maps/api/distancematrix/json",
      params: {
        origins: location,
        destinations: other.location,
        key: ENV["GOOGLE_API_KEY"]
      }
    ).parse.on_steroids!
  end

  private def split_preferences
    preference.to_s.split(",")
  end
end
