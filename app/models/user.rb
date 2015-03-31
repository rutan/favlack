# Slackのユーザ情報
# @attr [String] uid
# @attr [String] name
# @attr [String] avatar_url
class User < ActiveRecord::Base
  has_many :messages, -> { where('score > ?', 0) }
  has_many :stars
  has_many :star_messages,
           -> { stared.list },
           through: :stars,
           source: :message

  validates :uid,
            length: 1..32,
            format: /\AU.+/

  validates :name,
            length: 1..64

  validates :avatar_url,
            length: 1..255,
            format: /\Ahttps?:\/\/.+/

  def to_param
    self.name
  end

  # uidを元にSlackから情報を問い合わせて更新する
  # @param [SlackRepository] slack_repository
  # @return [Boolean]
  def fetch(slack_repository)
    response = slack_repository.client.users_info(user: self.uid)
    return false unless response['ok']
    self.apply_item Slacks::UserItem.new(response['user'])
  end

  # 指定情報を適用して保存する
  # @param [Slacks::UserItem] item
  # @return [Boolean]
  def apply_item(item)
    self.name = item.name
    self.avatar_url = item.profile.image_48
    self.save
  end

  # ユーザ情報をDBから取得、またはSlackAPIに問い合わせる
  # @param [SlackRepository] repository
  # @param [String] uid
  # @return [User]
  def self.find_or_fetch(repository, uid)
    user = self.find_or_initialize_by(uid: uid)
    user.fetch(repository) if user.new_record?
    user.new_record? ? nil : user
  end

  # ユーザ情報をDBから取得しSlackAPIに問い合わせる
  # DB未登録時は新規に登録する
  # @param [SlackRepository] repository
  # @param [String] uid
  # @return [User]
  def self.find_and_fetch(repository, uid)
    user = self.find_or_initialize_by(uid: uid)
    user.fetch(repository)
    user.new_record? ? nil : user
  end
end

