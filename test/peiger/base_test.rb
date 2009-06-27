class BaseTest < Test::Unit::TestCase

  def setup
    @base = Peiger::Base.new
  end

  def teardown
    @base = nil
  end

  def test_init_should_have_a_collections_array
    assert_equal [], @base.collections
  end

  def test_init_should_set_selected_to_false!
    assert_equal false, @base.selected?
  end

  def test_should_not_add_a_collection_object_when_empty
    assert_equal 0, @base.collections.size
    @base.add_collection Peiger::Collection.new(1)
    assert_equal 0, @base.collections.size
  end

  def test_should_not_change_if_non_collection_object_is_given
    assert_equal 0, @base.collections.size
    @base.add_collection 0
    @base.add_collection false
    @base.add_collection nil
    @base.add_collection true
    @base.add_collection Peiger::Collection
    assert_equal 0, @base.collections.size
  end

  def test_must_crate_various_collections
    10.times do |i|
      col =  Peiger::Collection.new(i)
      col << Peiger::Item.new(1, 1)
      @base.add_collection col
    end
    assert_equal 10, @base.collections.size
  end

  def test_must_crate_various_collections_and_get_their_ids
    10.times do |i|
      col =  Peiger::Collection.new(i)
      col << Peiger::Item.new(1, 1)
      @base.add_collection col
    end
    assert_equal Array(0..9), @base.collections.collect { |c| c.id }
  end

  def test_has_collection_must_be_true_when_collection_exists
    10.times do |i|
      col =  Peiger::Collection.new(i)
      col << Peiger::Item.new(1, 1)
      @base.add_collection col
    end
    assert @base.has_collection?(1)
    assert @base.has_collection?(9)
  end

  def test_has_collection_must_be_false_when_collection_does_not_exist
    10.times do |i|
      col =  Peiger::Collection.new(i)
      col << Peiger::Item.new(1, 1)
      @base.add_collection col
    end
    assert_equal false, @base.has_collection?(10)
  end

  def test_collection_must_return_it_when_it_exists
    one = Peiger::Collection.new(1)
    three = Peiger::Collection.new(3)

    one << Peiger::Item.new(1, 1)
    three << Peiger::Item.new(1, 1)

    @base.add_collection one
    @base.add_collection three

    assert_equal one, @base.collection(1)
    assert_equal three, @base.collection(3)
  end

  def test_collection_must_return_nil_when_it_does_not_exist
    @base.add_collection Peiger::Collection.new(1)
    @base.add_collection Peiger::Collection.new(3)

    assert_equal nil, @base.collection(0)
    assert_equal nil, @base.collection(2)
  end

  def test_select_must_select_a_valid_item_from_added_collections
    collection = Peiger::Collection.new(1)
    collection << Peiger::Item.new(1, 0)
    collection << Peiger::Item.new(2, 1)
    collection << Peiger::Item.new(3, 2)
    @base.add_collection collection

    collection = Peiger::Collection.new(2)
    collection << Peiger::Item.new(1, 0)
    collection << Peiger::Item.new(2, 1)
    collection << Peiger::Item.new(3, 2)
    @base.add_collection collection

    @base.add_collection Peiger::Collection.new(5)

    hash = { :item_id => 1, :collection_id => 1 }
    assert @base.select(1, 1)
    assert_equal hash, @base.selection
    assert @base.selected?
  end

end
