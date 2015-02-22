# 投稿メッセージ
# @attr [Integer] user_id
# @attr [Integer] channel_id
# @attr [String] body
# @attr [String] permalink
# @attr [String] ts
# @attr [Integer] score
class Message < ActiveRecord::Base
  scope :stared, -> { where('score > ?', 0) }
  scope :popular, -> { stared.order(score: :desc) }
  scope :list, -> { stared.order(updated_at: :desc) }

  belongs_to :user
  belongs_to :channel
  has_many :stars

  validates :user,
            presence: true

  validates :channel,
            presence: true

  validates :body,
            length: 1..4096

  validates :permalink,
            length: 1..255,
            format: /\Ahttps?:\/\/.+/

  def to_param
    self.ts
  end

  # 自分のスコア(fav数)を再計算して保存する
  def calc_score
    self.update(score: self.stars.count)
  end

  def posted_at
    Time.zone.at(self.ts.to_f)
  end
end
