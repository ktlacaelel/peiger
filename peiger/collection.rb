module Peiger

  class Collection

    attr_accessor :id, :items

    def initialize(collection_id)
      @id = collection_id
      @items = []
    end

    def <<(item)
      return false unless item.is_a? Peiger::Item
      if item_ids.include? item.id
        raise ItemRepeatedError.new(
          "Item:id[#{item.id}] already in collection")
      end
      if item_orders.include? item.order
        raise ItemRepeatedError.new(
          "Item:order[#{item.order}] already in collection")
      end
      @items << item
      @items = items
    end

    def get_item(item_id)
      items.each { |x| return x if x.id == item_id }
    end

    def has_item?(item_id)
      item_ids.include? item_id
    end

    def item_ids
      items.collect { |item| item.id }
    end

    def has_order?(item_id)
      item_orders.include? item_id
    end

    def last_item
      items.last
    end

    def next_order?(item_id)
      return false unless has_item? item_id
      current = get_item(item_id)
      items.each { |item| return true if item.order > current.order }
      false
    end

    def next_order(item_id)
      current = get_item(item_id)
      items.each do |item|
       return item if item.order > current.order
      end
    end

    def prev_order?(item_id)
      return false unless has_item? item_id
      current = get_item(item_id)
      items.reverse.each { |item| return true if item.order < current.order }
      false
    end

    def prev_order(item_id)
      current = get_item(item_id)
      items.reverse.each do |item|
       return item if item.order < current.order
      end
    end

    def item_orders
      items.collect { |item| item.order }
    end

    def items
      @items.sort_by { |item| item.order }
    end

  end

end
