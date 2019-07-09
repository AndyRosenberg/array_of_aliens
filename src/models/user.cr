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
end
