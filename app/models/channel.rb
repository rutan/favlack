# Slackの公開チャンネル
# @attr [String] uid
# @attr [String] name
class Channel < ActiveRecord::Base
  scope :list, -> { order(name: :asc) }

  has_many :messages, -> { where('score > ?', 0).order(ts: :desc) }

  validates :uid,
            length: 1..32,
            format: /\AC.+/

  validates :name,
            length: 1..64

  def to_param
    self.name
  end

  # uidを元にSlackから情報を問い合わせて更新する
  # @param [SlackRepository] slack_repository
  # @return [Boolean]
  def fetch(slack_repository)
    response = slack_repository.client.channels_info(channel: self.uid)
    return false unless response['ok']
    self.apply_item Slacks::ChannelItem.new(response['channel'])
  end

  # 指定情報を適用して保存する
  # @param [Slacks::ChannelItem] item
  # @return [Boolean]
  def apply_item(item)
    return false unless item.public?
    self.name = item.name
    self.save
  end

  # 非表示リストに追加されているか？
  # 環境変数 HIDDEN_CHANNELS に追加されている名前を持つチャンネルはログを表示しない
  # @return [Boolean]
  def hidden?
    (ENV['HIDDEN_CHANNELS'].to_s).split(/,/).map { |n| n.sub(/\A#/, '') }.include?(self.name)
  end

  # チャンネル情報をDBから取得、またはSlackAPIに問い合わせる
  # @param [SlackRepository] repository
  # @param [String] uid
  # @return [Channel]
  def self.find_or_fetch(repository, uid)
    channel = self.find_or_initialize_by(uid: uid)
    channel.fetch(repository) if channel.new_record?
    channel.new_record? ? nil : channel
  end
end
