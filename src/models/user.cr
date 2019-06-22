class User < Granite::Base
  @distances = JSON::OnSteroids.new

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

  def my_distances
    @distances = JSON.parse(distances || Hash(String, String | Int32).new.to_json).on_steroids!
  end
  
  def location
    "#{city} #{state}"
  end

  def possible_location?
    city && state
  end

  def no_locations_from_either?(other : User)
    possible_location? && other.possible_location?
  end

  def current_distance_from?(other : User)
    return false unless @distance["#{other.id}"] && @distance["#{other.id}"]["location"] == other.location
    @distance["#{other.id}"]["distance"]
  end
  
  def maps_distance_from(other : User)
    begin
      raise "" if no_locations_from_either?(other)
      req = GoogleMapsApi::Client.get("directions", {:origin => "#{location}", :destination => "#{other.location}"})
      req = JSON.parse(req.to_s).on_steroids!
      req[0]["legs"][0]["distance"]["value"]
    rescue exception
      999999
    end
  end

  def save_new_distance(other : User)
    @distances[other.id] = { :distance => maps_distance_from(other), :location => other.location }
    self.distances = @distances.to_json
    save
  end

  def get_distance(other : User)
    current_distance_from?(other) || save_new_distance(other)
    current_distance_from?(other)
  end
end
