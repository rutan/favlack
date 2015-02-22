module Slacks
  class StarItem
    def initialize(params = {})
      self.user_id = params['user']
      self.event_ts = params['event_ts']
      load_item(params['item'])
    end

    attr_accessor :user_id
    attr_accessor :item_type
    attr_accessor :item
    attr_accessor :event_ts

    def message?
      self.item_type == 'message'
    end

    private

    def load_item(item)
      self.item_type = item['type']
      case self.item_type
      when 'message'
        self.item = MessageItem.new(item)
      else
        self.item = nil
      end
    end
  end
end
