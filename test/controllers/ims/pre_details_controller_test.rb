require 'test_helper'

class Ims::PreDetailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ims_pre_detail = ims_pre_details(:one)
  end

  test "should get index" do
    get ims_pre_details_url
    assert_response :success
  end

  test "should get new" do
    get new_ims_pre_detail_url
    assert_response :success
  end

  test "should create ims_pre_detail" do
    assert_difference('Ims::PreDetail.count') do
      post ims_pre_details_url, params: { ims_pre_detail: { amount: @ims_pre_detail.amount, author_id: @ims_pre_detail.author_id, author_name: @ims_pre_detail.author_name, base_unit: @ims_pre_detail.base_unit, course_of_treatment_unit: @ims_pre_detail.course_of_treatment_unit, course_of_treatment_value: @ims_pre_detail.course_of_treatment_value, dose_unit: @ims_pre_detail.dose_unit, dose_value: @ims_pre_detail.dose_value, drug_id: @ims_pre_detail.drug_id, encounter_id: @ims_pre_detail.encounter_id, factory_name: @ims_pre_detail.factory_name, formul_code: @ims_pre_detail.formul_code, formul_display: @ims_pre_detail.formul_display, frequency_code: @ims_pre_detail.frequency_code, frequency_display: @ims_pre_detail.frequency_display, hospital_prescription_detail_id: @ims_pre_detail.hospital_prescription_detail_id, measure_unit: @ims_pre_detail.measure_unit, measure_val: @ims_pre_detail.measure_val, mul: @ims_pre_detail.mul, note: @ims_pre_detail.note, order_type: @ims_pre_detail.order_type, ori_detail_id: @ims_pre_detail.ori_detail_id, price: @ims_pre_detail.price, purch_mul: @ims_pre_detail.purch_mul, purch_unit: @ims_pre_detail.purch_unit, qty: @ims_pre_detail.qty, return_qty: @ims_pre_detail.return_qty, route_code: @ims_pre_detail.route_code, route_display: @ims_pre_detail.route_display, sale_unit: @ims_pre_detail.sale_unit, send_qty: @ims_pre_detail.send_qty, single_qty_unit: @ims_pre_detail.single_qty_unit, single_qty_value: @ims_pre_detail.single_qty_value, specification: @ims_pre_detail.specification, status: @ims_pre_detail.status, title: @ims_pre_detail.title, type_type: @ims_pre_detail.type_type, unit: @ims_pre_detail.unit } }
    end

    assert_redirected_to ims_pre_detail_url(Ims::PreDetail.last)
  end

  test "should show ims_pre_detail" do
    get ims_pre_detail_url(@ims_pre_detail)
    assert_response :success
  end

  test "should get edit" do
    get edit_ims_pre_detail_url(@ims_pre_detail)
    assert_response :success
  end

  test "should update ims_pre_detail" do
    patch ims_pre_detail_url(@ims_pre_detail), params: { ims_pre_detail: { amount: @ims_pre_detail.amount, author_id: @ims_pre_detail.author_id, author_name: @ims_pre_detail.author_name, base_unit: @ims_pre_detail.base_unit, course_of_treatment_unit: @ims_pre_detail.course_of_treatment_unit, course_of_treatment_value: @ims_pre_detail.course_of_treatment_value, dose_unit: @ims_pre_detail.dose_unit, dose_value: @ims_pre_detail.dose_value, drug_id: @ims_pre_detail.drug_id, encounter_id: @ims_pre_detail.encounter_id, factory_name: @ims_pre_detail.factory_name, formul_code: @ims_pre_detail.formul_code, formul_display: @ims_pre_detail.formul_display, frequency_code: @ims_pre_detail.frequency_code, frequency_display: @ims_pre_detail.frequency_display, hospital_prescription_detail_id: @ims_pre_detail.hospital_prescription_detail_id, measure_unit: @ims_pre_detail.measure_unit, measure_val: @ims_pre_detail.measure_val, mul: @ims_pre_detail.mul, note: @ims_pre_detail.note, order_type: @ims_pre_detail.order_type, ori_detail_id: @ims_pre_detail.ori_detail_id, price: @ims_pre_detail.price, purch_mul: @ims_pre_detail.purch_mul, purch_unit: @ims_pre_detail.purch_unit, qty: @ims_pre_detail.qty, return_qty: @ims_pre_detail.return_qty, route_code: @ims_pre_detail.route_code, route_display: @ims_pre_detail.route_display, sale_unit: @ims_pre_detail.sale_unit, send_qty: @ims_pre_detail.send_qty, single_qty_unit: @ims_pre_detail.single_qty_unit, single_qty_value: @ims_pre_detail.single_qty_value, specification: @ims_pre_detail.specification, status: @ims_pre_detail.status, title: @ims_pre_detail.title, type_type: @ims_pre_detail.type_type, unit: @ims_pre_detail.unit } }
    assert_redirected_to ims_pre_detail_url(@ims_pre_detail)
  end

  test "should destroy ims_pre_detail" do
    assert_difference('Ims::PreDetail.count', -1) do
      delete ims_pre_detail_url(@ims_pre_detail)
    end

    assert_redirected_to ims_pre_details_url
  end
end
