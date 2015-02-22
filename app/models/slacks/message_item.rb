module Slacks
  class MessageItem
    def initialize(params = {})
      self.channel_id = params['channel']
      self.user_id = params['message']['user'] || params['message']['bot_id']
      self.text = params['message']['text']
      self.ts = params['message']['ts']
      self.permalink = params['message']['permalink']
    end

    attr_accessor :channel_id
    attr_accessor :user_id
    attr_accessor :text
    attr_accessor :ts
    attr_accessor :permalink

    def public?
      self.channel_id.to_s.index('C') == 0
    end

    def human?
      self.user_id.to_s.index('U') == 0
    end
  end
end
