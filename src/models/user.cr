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

  def set_distances
    empty_json = Hash(String, String | Int32).new.to_json
    @distances_on_roids = JSON.parse(distances || empty_json).on_steroids!
  end
  
  def location
    "#{city} #{state}"
  end

  def possible_location?
    !!(city && state)
  end

  def locations_from_both?(other : User)
    possible_location? && other.possible_location?
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
  
  def maps_distance_from(other : User)
    begin
      raise "" unless locations_from_both?(other)
      req = GoogleMapsApi::Client.get("directions", {:origin => "#{location}", :destination => "#{other.location}"})
      req = JSON.parse(req.to_s).on_steroids!
      req[0]["legs"][0]["distance"]["value"]
    rescue exception
      999999
    end
  end

  def save_new_distance(other : User)
    @distances_on_roids["#{other.id}"] = { "distance" => maps_distance_from(other), "location" => other.location }
    self.distances = @distances_on_roids.to_json
    save
  end

  def get_distance(other : User)
    set_distances
    current_distance = current_distance_from?(other)
    return current_distance if current_distance
    save_new_distance(other)
    current_distance_from?(other)
  end
end
