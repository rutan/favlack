module Slacks
  class UserItem
    def initialize(params = {})
      self.id = params['id']
      self.name = params['name']
      self.profile = OpenStruct.new(params['profile'] || {})
    end

    attr_accessor :id
    attr_accessor :name
    attr_accessor :profile
  end
end
