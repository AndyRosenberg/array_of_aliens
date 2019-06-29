class Image < Granite::Base
  adapter pg
  table_name images

  primary id : Int64
  user_id : Int64
  profile : Boolean
  object_key : String
  timestamps
end
