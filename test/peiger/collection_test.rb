class CollectionTest < Test::Unit::TestCase

  def setup
    @collection = Peiger::Collection.new(1)
  end

  def teardown
    @collection = nil
  end

  def test_col_must_have_id_and_empty_collection
    assert_equal @collection.id, 1
    assert_equal @collection.items, []
  end

  def test_collection_should_add_items
    assert_equal 1, @collection.id
    @collection << Peiger::Item.new(1, 0)
    assert_equal 0, @collection.items.first.order
    assert_equal 1, @collection.items.first.id
  end

  def test_should_contain_number_of_added_items
    assert_equal @collection.id, 1
    @collection << Peiger::Item.new(1, 0)
    @collection << Peiger::Item.new(2, 1)
    assert_equal 2, @collection.items.size
  end

  def test_should_not_accept_non_item_objects
    @collection << 0
    @collection << nil
    @collection << false
    @collection << {}
    @collection << { :order => 1, :id => 1 }
    @collection << Peiger::Item
    assert_equal 0, @collection.items.size
  end

  def test_should_not_accept_items_with_the_same_id
    @collection << Peiger::Item.new(1, 1)
    assert_raise Peiger::ItemRepeatedError do
      @collection << Peiger::Item.new(1, 2)
    end
    assert_equal 1, @collection.items.size
    assert_equal 1, @collection.items.first.id
  end

  def test_should_not_accept_items_with_the_same_order
    @collection << Peiger::Item.new(1, 1)
    assert_raise Peiger::ItemRepeatedError do
      @collection << Peiger::Item.new(2, 1)
      @collection << Peiger::Item.new(3, 1)
    end
    assert_equal 1, @collection.items.size
    assert_equal 1, @collection.items.first.order
    assert_equal 1, @collection.items.first.id
  end

  def test_items_should_return_ordered_by_item_order
    @collection << Peiger::Item.new(8, 5)
    @collection << Peiger::Item.new(2, 4)
    @collection << Peiger::Item.new(9, 3)
    @collection << Peiger::Item.new(1, 2)
    @collection << Peiger::Item.new(0, 1)

    expect = [
      Peiger::Item.new(0, 1),
      Peiger::Item.new(1, 2),
      Peiger::Item.new(9, 3),
      Peiger::Item.new(2, 4),
      Peiger::Item.new(8, 5),
    ]

    assert_equal expect.size, @collection.items.size
    assert_equal expect.collect { |x| x.order }, @collection.items.collect { |x| x.order }
  end

  def test_item_ids_must_match_item_ids
    @collection << Peiger::Item.new(8, 5)
    @collection << Peiger::Item.new(2, 4)
    @collection << Peiger::Item.new(9, 3)
    @collection << Peiger::Item.new(1, 2)
    @collection << Peiger::Item.new(0, 1)
    assert_equal [0, 1, 9, 2, 8], @collection.item_ids
  end

  def test_item_orders_must_match_item_orders
    @collection << Peiger::Item.new(8, 5)
    @collection << Peiger::Item.new(2, 4)
    @collection << Peiger::Item.new(9, 3)
    @collection << Peiger::Item.new(1, 2)
    @collection << Peiger::Item.new(0, 1)
    assert_equal [1, 2, 3, 4, 5], @collection.item_orders
  end

  def test_has_item_must_return_true_when_item_was_added
    @collection << Peiger::Item.new(2, 4)
    @collection << Peiger::Item.new(1, 2)
    @collection << Peiger::Item.new(0, 1)
    assert @collection.has_item?(1)
    assert @collection.has_item?(2)
    assert @collection.has_item?(0)
  end

  def test_has_item_must_return_true_when_item_was_added
    @collection << Peiger::Item.new(2, 4)
    @collection << Peiger::Item.new(1, 2)
    @collection << Peiger::Item.new(0, 1)
    assert_equal false, @collection.has_item?(-1)
    assert_equal false, @collection.has_item?(3)
  end

  def test_has_order_must_return_true_when_added
    @collection << Peiger::Item.new(2, 4)
    @collection << Peiger::Item.new(1, 2)
    assert @collection.has_order?(4)
    assert @collection.has_order?(2)
  end

  def test_has_order_must_return_false_when_not_added
    @collection << Peiger::Item.new(2, 4)
    @collection << Peiger::Item.new(1, 2)
    assert_equal false, @collection.has_order?(-1)
    assert_equal false, @collection.has_order?(3)
  end

  def test_must_return_true_when_there_is_a_next_order
    @collection << Peiger::Item.new(2, 1)
    @collection << Peiger::Item.new(1, 0)
    assert @collection.next_order?(1)
  end

  def test_must_return_false_when_there_is_no_next_order
    @collection << Peiger::Item.new(1, 10)
    @collection << Peiger::Item.new(2, 20)
    @collection << Peiger::Item.new(4, 40)
    @collection << Peiger::Item.new(3, 30)
    assert_equal false, @collection.next_order?(4)
    assert_equal false, @collection.next_order?(6)
    assert_equal false, @collection.next_order?(-1)
  end

  def test_must_return_false_when_there_given_item_does_not_exist
    @collection << Peiger::Item.new(2, 1)
    @collection << Peiger::Item.new(1, 0)
    assert_equal false, @collection.next_order?(5)
    assert_equal false, @collection.next_order?(0)
    assert_equal false, @collection.next_order?(3)
  end

  def test_must_get_next_ordered_item
    @collection << Peiger::Item.new(2, 1)
    @collection << Peiger::Item.new(1, 0)
    assert_equal true, @collection.next_order?(1)
    assert @collection.next_order(1).is_a?(Peiger::Item)
  end

end
