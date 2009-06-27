module Peiger

  class Base

    attr_accessor :collections

    def initialize
      @collections = []
      @selected = false
      @selected_collection_id = nil
      @selected_item_id = nil
    end

    def add_collection(collection)
      return false unless collection.is_a? Peiger::Collection
      @collections << collection
      remove_empty_collections
      @collections = @collections.sort_by { |c| c.id }
    end

    def has_collection?(collection_id)
      @collections.collect { |c| c.id }.include? collection_id
    end

    def collection_ids
      @collections.collect { |x| x.id }
    end

    def prev_collection?(col_id)
      collection_ids.reverse.each { |id| return true if col_id > id }
      false
    end

    def prev_collection(col_id)
      @collections.reverse.each { |col| return col if col_id > col.id }
      return @collections.last
    end

    def next_collection?(col_id)
      collection_ids.each { |id| return true if col_id < id }
      false
    end

    def next_collection(col_id)
      @collections.each { |col| return col if col_id < col.id }
      return @collections.first
    end

    def collection(collection_id)
      @collections.each { |c| return c if c.id  == collection_id }
      nil
    end

    def remove_empty_collections
      @collections = @collections.collect do |col|
        col if col.items.size > 0
      end.compact
    end

    def select(item_id, collection_id)
      if has_collection?(collection_id) && collection(collection_id).has_item?(item_id)
        @selected_item_id = item_id
        @selected_collection_id = collection_id
        @selected = true
      end
      selected?
    end

    def selection
      {
        :item_id => @selected_item_id,
        :collection_id => @selected_collection_id
      }
    end

    def selected?
      @selected == true
    end

    def next
      get_angry_if_trying_to_paginate_with_no_data
      return select_first_item_from_collection(@collections.first) unless selected?
      fetch_next_item
    end

    def prev
      get_angry_if_trying_to_paginate_with_no_data
      return select_last_item_from_collection(@collections.last) unless selected?
      fetch_prev_item
    end

    private

    def get_angry_if_trying_to_paginate_with_no_data
      if @collections == []
        raise Peiger::PeigerError.new('Nothing to paginate')
      end
    end

    def select_first_item_from_collection(col)
      select col.item_ids.first, col.id
      selection
    end

    def select_last_item_from_collection(col)
      select col.item_ids.last, col.id
      selection
    end

    def fetch_next_item
      col = collection(@selected_collection_id)
      if col.next_order? @selected_item_id
        select col.next_order(@selected_item_id).id, @selected_collection_id
        return selection
      end
      col = next_collection(@selected_collection_id)
      select col.item_ids.first, col.id
      return selection
    end

    def fetch_prev_item
      col = collection(@selected_collection_id)
      if col.prev_order? @selected_item_id
        select col.prev_order(@selected_item_id).id, @selected_collection_id
        return selection
      end
      col = prev_collection(@selected_collection_id)
      select col.item_ids.last, col.id
      return selection
    end

  end
end
