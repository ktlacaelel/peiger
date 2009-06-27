class ItemTest < Test::Unit::TestCase

  def setup
    @item = Peiger::Item.new(1, 2)
  end

  def teardown
    @item = nil
  end

  def test_item_should_have_item_and_order_values_when_init
    assert_equal @item.order, 2
    assert_equal @item.id, 1
  end

end
