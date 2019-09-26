class Conversation < Granite::Base
  adapter pg
  table_name conversations

  primary id : Int64
  field starter_id : Int64
  field recipient_id : Int64
  timestamps
  has_many :messages, class_name: Message
  has_many :user, through: :messages

  def non_current_user_id(current_user : User | Nil)
    return nil unless current_user
    current_user ||= User.new
    user.find { |user| user.id != current_user.id }.try(&.id)
  end
end
