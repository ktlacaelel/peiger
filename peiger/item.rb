module Peiger

  class Item

    attr_accessor :order, :id

    def initialize(item_id, item_order)
      @id = item_id
      @order = item_order
    end

  end

end
