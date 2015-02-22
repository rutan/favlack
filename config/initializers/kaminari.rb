require 'kaminari'

module Kaminari
  module Helpers
    class Paginator < Tag
      # override
      def render(&block)
        instance_eval(&block)
        @output_buffer
      end
    end
  end
end
