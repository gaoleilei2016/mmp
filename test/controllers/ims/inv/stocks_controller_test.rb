require 'test_helper'

class Ims::Inv::StocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ims_inv_stock = ims_inv_stocks(:one)
  end

  test "should get index" do
    get ims_inv_stocks_url
    assert_response :success
  end

  test "should get new" do
    get new_ims_inv_stock_url
    assert_response :success
  end

  test "should create ims_inv_stock" do
    assert_difference('Ims::Inv::Stock.count') do
      post ims_inv_stocks_url, params: { ims_inv_stock: { amount: @ims_inv_stock.amount, batch: @ims_inv_stock.batch, code: @ims_inv_stock.code, created_at: @ims_inv_stock.created_at, freeze_qty: @ims_inv_stock.freeze_qty, location_id: @ims_inv_stock.location_id, location_name: @ims_inv_stock.location_name, medicine_id: @ims_inv_stock.medicine_id, mul: @ims_inv_stock.mul, org_id: @ims_inv_stock.org_id, price: @ims_inv_stock.price, pt_code: @ims_inv_stock.pt_code, quantity: @ims_inv_stock.quantity, unit: @ims_inv_stock.unit, updated_at: @ims_inv_stock.updated_at } }
    end

    assert_redirected_to ims_inv_stock_url(Ims::Inv::Stock.last)
  end

  test "should show ims_inv_stock" do
    get ims_inv_stock_url(@ims_inv_stock)
    assert_response :success
  end

  test "should get edit" do
    get edit_ims_inv_stock_url(@ims_inv_stock)
    assert_response :success
  end

  test "should update ims_inv_stock" do
    patch ims_inv_stock_url(@ims_inv_stock), params: { ims_inv_stock: { amount: @ims_inv_stock.amount, batch: @ims_inv_stock.batch, code: @ims_inv_stock.code, created_at: @ims_inv_stock.created_at, freeze_qty: @ims_inv_stock.freeze_qty, location_id: @ims_inv_stock.location_id, location_name: @ims_inv_stock.location_name, medicine_id: @ims_inv_stock.medicine_id, mul: @ims_inv_stock.mul, org_id: @ims_inv_stock.org_id, price: @ims_inv_stock.price, pt_code: @ims_inv_stock.pt_code, quantity: @ims_inv_stock.quantity, unit: @ims_inv_stock.unit, updated_at: @ims_inv_stock.updated_at } }
    assert_redirected_to ims_inv_stock_url(@ims_inv_stock)
  end

  test "should destroy ims_inv_stock" do
    assert_difference('Ims::Inv::Stock.count', -1) do
      delete ims_inv_stock_url(@ims_inv_stock)
    end

    assert_redirected_to ims_inv_stocks_url
  end
end
