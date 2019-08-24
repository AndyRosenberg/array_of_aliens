class Conversation < Granite::Base
  adapter pg
  table_name conversations

  primary id : Int64
  timestamps
  has_many :user
  has_many :message
end
