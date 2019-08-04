module Ransack
  module Helpers
    module FormHelper
      class SortLink
        def name
          order_indicator.html_safe
        end

        private
          def order_indicator
            return if @hide_indicator
            if @current_dir == 'desc'.freeze
              up_arrow
            elsif @current_dir == 'asc'.freeze
              down_arrow
            else
              up_arrow + down_arrow
            end
          end
      end
    end
  end
end

Ransack.configure do |config|
  config.custom_arrows = {
    up_arrow: '<i class="fa fa-caret-up"></i>',
    down_arrow: '<i class="fa fa-caret-down"></i>'
  }
end