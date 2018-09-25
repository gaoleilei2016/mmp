require 'test_helper'

class Ims::IpdsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ims_ipd = ims_ipds(:one)
  end

  test "should get index" do
    get ims_ipds_url
    assert_response :success
  end

  test "should get new" do
    get new_ims_ipd_url
    assert_response :success
  end

  test "should create ims_ipd" do
    assert_difference('Ims::Ipd.count') do
      post ims_ipds_url, params: { ims_ipd: { amount: @ims_ipd.amount, author_id: @ims_ipd.author_id, author_name: @ims_ipd.author_name, base_unit: @ims_ipd.base_unit, course_of_treatment_unit: @ims_ipd.course_of_treatment_unit, course_of_treatment_value: @ims_ipd.course_of_treatment_value, dose_unit: @ims_ipd.dose_unit, dose_value: @ims_ipd.dose_value, drug_id: @ims_ipd.drug_id, encounter_id: @ims_ipd.encounter_id, factory_name: @ims_ipd.factory_name, formul_code: @ims_ipd.formul_code, formul_display: @ims_ipd.formul_display, frequency_code: @ims_ipd.frequency_code, frequency_display: @ims_ipd.frequency_display, hospital_prescription_detail_id: @ims_ipd.hospital_prescription_detail_id, measure_unit: @ims_ipd.measure_unit, measure_val: @ims_ipd.measure_val, mul: @ims_ipd.mul, note: @ims_ipd.note, order_type: @ims_ipd.order_type, ori_detail_id: @ims_ipd.ori_detail_id, price: @ims_ipd.price, purch_mul: @ims_ipd.purch_mul, purch_unit: @ims_ipd.purch_unit, qty: @ims_ipd.qty, return_qty: @ims_ipd.return_qty, route_code: @ims_ipd.route_code, route_display: @ims_ipd.route_display, sale_unit: @ims_ipd.sale_unit, send_qty: @ims_ipd.send_qty, single_qty_unit: @ims_ipd.single_qty_unit, single_qty_value: @ims_ipd.single_qty_value, specification: @ims_ipd.specification, status: @ims_ipd.status, title: @ims_ipd.title, type_type: @ims_ipd.type_type, unit: @ims_ipd.unit } }
    end

    assert_redirected_to ims_ipd_url(Ims::Ipd.last)
  end

  test "should show ims_ipd" do
    get ims_ipd_url(@ims_ipd)
    assert_response :success
  end

  test "should get edit" do
    get edit_ims_ipd_url(@ims_ipd)
    assert_response :success
  end

  test "should update ims_ipd" do
    patch ims_ipd_url(@ims_ipd), params: { ims_ipd: { amount: @ims_ipd.amount, author_id: @ims_ipd.author_id, author_name: @ims_ipd.author_name, base_unit: @ims_ipd.base_unit, course_of_treatment_unit: @ims_ipd.course_of_treatment_unit, course_of_treatment_value: @ims_ipd.course_of_treatment_value, dose_unit: @ims_ipd.dose_unit, dose_value: @ims_ipd.dose_value, drug_id: @ims_ipd.drug_id, encounter_id: @ims_ipd.encounter_id, factory_name: @ims_ipd.factory_name, formul_code: @ims_ipd.formul_code, formul_display: @ims_ipd.formul_display, frequency_code: @ims_ipd.frequency_code, frequency_display: @ims_ipd.frequency_display, hospital_prescription_detail_id: @ims_ipd.hospital_prescription_detail_id, measure_unit: @ims_ipd.measure_unit, measure_val: @ims_ipd.measure_val, mul: @ims_ipd.mul, note: @ims_ipd.note, order_type: @ims_ipd.order_type, ori_detail_id: @ims_ipd.ori_detail_id, price: @ims_ipd.price, purch_mul: @ims_ipd.purch_mul, purch_unit: @ims_ipd.purch_unit, qty: @ims_ipd.qty, return_qty: @ims_ipd.return_qty, route_code: @ims_ipd.route_code, route_display: @ims_ipd.route_display, sale_unit: @ims_ipd.sale_unit, send_qty: @ims_ipd.send_qty, single_qty_unit: @ims_ipd.single_qty_unit, single_qty_value: @ims_ipd.single_qty_value, specification: @ims_ipd.specification, status: @ims_ipd.status, title: @ims_ipd.title, type_type: @ims_ipd.type_type, unit: @ims_ipd.unit } }
    assert_redirected_to ims_ipd_url(@ims_ipd)
  end

  test "should destroy ims_ipd" do
    assert_difference('Ims::Ipd.count', -1) do
      delete ims_ipd_url(@ims_ipd)
    end

    assert_redirected_to ims_ipds_url
  end
end
