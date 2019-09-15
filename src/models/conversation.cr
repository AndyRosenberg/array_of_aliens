class Conversation < Granite::Base
  adapter pg
  table_name conversations

  primary id : Int64
  timestamps
  has_many :message

  def non_current_user_id(current_user : User | Nil)
    return nil unless current_user
    current_user ||= User.new
    message.map(&.user_id).uniq.reject(&.==(current_user.id))[0]?
  end
end
