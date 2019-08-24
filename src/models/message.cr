class Message < Granite::Base
  adapter pg
  table_name messages

  primary id : Int64
  timestamps
  field body : String
  belongs_to :user
  belongs_to :conversation
end
