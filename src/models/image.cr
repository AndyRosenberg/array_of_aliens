class Image < Granite::Base
  adapter pg
  table_name images

  primary id : Int64
  user_id : Int64
  profile : Bool
  object_key : String
  timestamps

  def generate_key
    Random::Secure.hex(15)
  end
end
