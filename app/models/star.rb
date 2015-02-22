# お気に入り情報
# @attr [Integer] user_id
# @attr [Integer] message_id
class Star < ActiveRecord::Base
  belongs_to :user
  belongs_to :message

  validates :user,
            presence: true

  validates :message,
            presence: true

  after_save :update_message_score
  after_destroy :update_message_score

  private

  def update_message_score
    self.message.calc_score if self.message
  end

  def self.link(user, message)
    self.find_or_create_by(user_id: user.id, message_id: message.id)
  end

  def self.unlink(user, message)
    self.find_by(user_id: user.id, message_id: message.id).try(:destroy)
  end
end
