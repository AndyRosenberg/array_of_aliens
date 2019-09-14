class Conversation < Granite::Base
  adapter pg
  table_name conversations

  primary id : Int64
  timestamps
  has_many :message
  has_many :user, through: :message

  def not_current_user(current_user : User | Nil)
    current_user ||= User.new
    msg = message.reject { |msg| msg.user_id != current_user.id }[0]?
    msg.user if msg
  end
end
