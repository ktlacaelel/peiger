class BaseWithDataTest < Test::Unit::TestCase

  def setup
    @base = Peiger::Base.new

    collection = Peiger::Collection.new(1)
    collection << Peiger::Item.new(1, 0)
    collection << Peiger::Item.new(2, 1)
    collection << Peiger::Item.new(3, 2)
    collection << Peiger::Item.new(4, 3)
    @base.add_collection collection

    collection = Peiger::Collection.new(2)
    collection << Peiger::Item.new(1, 0)
    collection << Peiger::Item.new(2, 1)
    collection << Peiger::Item.new(3, 2)
    collection << Peiger::Item.new(4, 3)
    @base.add_collection collection

    collection = Peiger::Collection.new(3)
    collection << Peiger::Item.new(1, 0)
    collection << Peiger::Item.new(2, 1)
    collection << Peiger::Item.new(3, 2)
    collection << Peiger::Item.new(4, 3)
    @base.add_collection collection

    collection = Peiger::Collection.new(4)
    collection << Peiger::Item.new(1, 0)
    collection << Peiger::Item.new(2, 1)
    collection << Peiger::Item.new(3, 2)
    collection << Peiger::Item.new(4, 3)
    @base.add_collection collection

    @base.add_collection Peiger::Collection.new(5)
    @base.add_collection Peiger::Collection.new(6)

    assert_equal 4, @base.collections.size
  end

  def teardown
    @base = nil
  end

  def test_must_select_parameters_given
    @base.select 2, 1
    expect = { :item_id => 2, :collection_id => 1 }
    assert_equal expect, @base.selection
  end

  def test_next_should_raise_an_exception_when_next_is_executed_and_there_is_nothing_to_paginate
    assert_raises Peiger::PeigerError do
      Peiger::Base.new.next
    end
  end

  #
  #
  def test_next_should_return_first_record_when_nothing_is_selected
    expect = { :item_id => 1, :collection_id => 1 }
    assert_equal expect, @base.next
  end

  def test_prev_should_return_last_record_when_nothing_is_selected
    expect = { :item_id => 4, :collection_id => 4 }
    assert_equal expect, @base.prev
  end

  #
  #
  def test_next_must_return_next_item_from_collection
    @base.select 2, 1
    expect = { :item_id => 3, :collection_id => 1 }
    assert_equal expect, @base.next
  end

  def test_prev_must_return_prev_item_from_collection
    @base.select 2, 1
    expect = { :item_id => 1, :collection_id => 1 }
    assert_equal expect, @base.prev
  end

  #
  #
  def test_next_collection_should_return_true_when_it_exists
    @base.select 2, 1
    assert @base.next_collection?(1)
  end

  def test_prev_collection_should_return_true_when_it_exists
    @base.select 2, 1
    assert @base.prev_collection?(2)
  end

  #
  #
  def test_next_collection_should_return_FALSE_when_it_does_not_exist
    @base.select 2, 1
    assert_equal false, @base.next_collection?(9)
  end

  def test_prev_collection_should_return_FALSE_when_it_does_not_exist
    @base.select 2, 1
    assert_equal false, @base.prev_collection?(1)
  end

  #
  #
  def test_next_collection_should_return_collection_object
    @base.select 2, 1
    assert @base.next_collection?(1)
    assert_equal 2, @base.next_collection(1).id
  end

  def test_prev_collection_should_return_collection_object
    @base.select 2, 2
    assert @base.prev_collection?(2)
    assert_equal 1, @base.prev_collection(2).id
  end

  # must skip, when collection is not present and find the first one
  # from the end or the beginning
  #
  def test_next_collection_should_return_collection_object2
    @base.select 2, 4
    assert_equal false, @base.next_collection?(4)
    assert_equal 1, @base.next_collection(4).id
  end

  def test_prev_collection_should_return_collection_object2
    @base.select 2, 1
    assert_equal false, @base.prev_collection?(1)
    assert_equal 4, @base.prev_collection(1).id
  end

  #
  #
  def test_next_must_return_first_item_from_next_collection
    @base.select 4, 2
    expect = { :item_id => 1, :collection_id => 3 }
    assert_equal expect, @base.next
  end

  def test_prev_must_return_last_item_from_prev_collection
    @base.select 4, 2
    expect = { :item_id => 3, :collection_id => 2 }
    assert_equal expect, @base.prev
  end

  #
  #
  def test_next_collection_must_return_true_when_current_is_the_last
    @base.select 4, 4
    assert_equal false, @base.next_collection?(4)
  end

  def test_prev_collection_must_return_true_when_current_is_the_last
    @base.select 4, 4
    assert_equal true, @base.prev_collection?(4)
  end

  #
  #
  def test_next_must_skip_empty_collections_and_find_next_needed_item
    @base.select 4, 4
    expect = { :item_id => 1, :collection_id => 1 }
    assert_equal expect, @base.next
  end

  def test_prev_must_skip_empty_collections_and_find_prev_needed_item
    @base.select 4, 5
    expect = { :item_id => 4, :collection_id => 4 }
    assert_equal expect, @base.prev
  end

  #
  #
  def test_next_must_find_next_collection_and_first_item
    @base.select 4, 1
    expect = { :item_id => 1, :collection_id => 2 }
    assert_equal expect, @base.next
  end

  def test_prev_must_find_prev_collection_and_last_item
    @base.select 1, 3
    expect = { :item_id => 4, :collection_id => 2 }
    assert_equal expect, @base.prev
  end


end
