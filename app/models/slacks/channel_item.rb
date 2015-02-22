module Slacks
  class ChannelItem
    def initialize(params = {})
      self.id = params['id']
      self.name = params['name']
    end

    attr_accessor :id
    attr_accessor :name

    def public?
      self.id.to_s[0] == 'C'
    end
  end
end
