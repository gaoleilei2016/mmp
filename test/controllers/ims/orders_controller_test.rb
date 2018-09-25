require 'test_helper'

class Ims::OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ims_order = ims_orders(:one)
  end

  test "should get index" do
    get ims_orders_url
    assert_response :success
  end

  test "should get new" do
    get new_ims_order_url
    assert_response :success
  end

  test "should create ims_order" do
    assert_difference('Ims::Order.count') do
      post ims_orders_url, params: { ims_order: { created_at: @ims_order.created_at, note: @ims_order.note, operat_at: @ims_order.operat_at, operater: @ims_order.operater, order_code: @ims_order.order_code, ori_code: @ims_order.ori_code, ori_id: @ims_order.ori_id, patient_name: @ims_order.patient_name, patient_order_id: @ims_order.patient_order_id, repeat_number: @ims_order.repeat_number, search_name: @ims_order.search_name, source_org_ii: @ims_order.source_org_ii, source_org_name: @ims_order.source_org_name, target_org_ii: @ims_order.target_org_ii, target_org_name: @ims_order.target_org_name, total_amount: @ims_order.total_amount, updated_at: @ims_order.updated_at } }
    end

    assert_redirected_to ims_order_url(Ims::Order.last)
  end

  test "should show ims_order" do
    get ims_order_url(@ims_order)
    assert_response :success
  end

  test "should get edit" do
    get edit_ims_order_url(@ims_order)
    assert_response :success
  end

  test "should update ims_order" do
    patch ims_order_url(@ims_order), params: { ims_order: { created_at: @ims_order.created_at, note: @ims_order.note, operat_at: @ims_order.operat_at, operater: @ims_order.operater, order_code: @ims_order.order_code, ori_code: @ims_order.ori_code, ori_id: @ims_order.ori_id, patient_name: @ims_order.patient_name, patient_order_id: @ims_order.patient_order_id, repeat_number: @ims_order.repeat_number, search_name: @ims_order.search_name, source_org_ii: @ims_order.source_org_ii, source_org_name: @ims_order.source_org_name, target_org_ii: @ims_order.target_org_ii, target_org_name: @ims_order.target_org_name, total_amount: @ims_order.total_amount, updated_at: @ims_order.updated_at } }
    assert_redirected_to ims_order_url(@ims_order)
  end

  test "should destroy ims_order" do
    assert_difference('Ims::Order.count', -1) do
      delete ims_order_url(@ims_order)
    end

    assert_redirected_to ims_orders_url
  end
end
