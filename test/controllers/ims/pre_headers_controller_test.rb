require 'test_helper'

class Ims::PreHeadersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ims_pre_header = ims_pre_headers(:one)
  end

  test "should get index" do
    get ims_pre_headers_url
    assert_response :success
  end

  test "should get new" do
    get new_ims_pre_header_url
    assert_response :success
  end

  test "should create ims_pre_header" do
    assert_difference('Ims::PreHeader.count') do
      post ims_pre_headers_url, params: { ims_pre_header: { address: @ims_pre_header.address, age: @ims_pre_header.age, audit_at: @ims_pre_header.audit_at, auditor_id: @ims_pre_header.auditor_id, auditor_name: @ims_pre_header.auditor_name, author_id: @ims_pre_header.author_id, author_name: @ims_pre_header.author_name, birth_date: @ims_pre_header.birth_date, charge_at: @ims_pre_header.charge_at, charger_id: @ims_pre_header.charger_id, charger_name: @ims_pre_header.charger_name, confidentiality_code: @ims_pre_header.confidentiality_code, confidentiality_name: @ims_pre_header.confidentiality_name, create_bill_opt_id: @ims_pre_header.create_bill_opt_id, create_bill_opt_name: @ims_pre_header.create_bill_opt_name, delivery_at: @ims_pre_header.delivery_at, delivery_id: @ims_pre_header.delivery_id, delivery_name: @ims_pre_header.delivery_name, delivery_org_id: @ims_pre_header.delivery_org_id, delivery_org_name: @ims_pre_header.delivery_org_name, diagnoses: @ims_pre_header.diagnoses, drug_store_id: @ims_pre_header.drug_store_id, drug_store_name: @ims_pre_header.drug_store_name, effective_end: @ims_pre_header.effective_end, effective_start: @ims_pre_header.effective_start, encounter_loc_id: @ims_pre_header.encounter_loc_id, encounter_loc_name: @ims_pre_header.encounter_loc_name, gender_code: @ims_pre_header.gender_code, gender_name: @ims_pre_header.gender_name, hospital_prescription_at: @ims_pre_header.hospital_prescription_at, hospital_prescription_id: @ims_pre_header.hospital_prescription_id, iden: @ims_pre_header.iden, is_return: @ims_pre_header.is_return, name: @ims_pre_header.name, note: @ims_pre_header.note, occupation_code: @ims_pre_header.occupation_code, occupation_name: @ims_pre_header.occupation_name, order_at: @ims_pre_header.order_at, order_code: @ims_pre_header.order_code, order_id: @ims_pre_header.order_id, ori_code: @ims_pre_header.ori_code, ori_id: @ims_pre_header.ori_id, patient_no: @ims_pre_header.patient_no, phone: @ims_pre_header.phone, prescription_no: @ims_pre_header.prescription_no, reason: @ims_pre_header.reason, return_at: @ims_pre_header.return_at, return_id: @ims_pre_header.return_id, return_name: @ims_pre_header.return_name, return_org_id: @ims_pre_header.return_org_id, return_org_name: @ims_pre_header.return_org_name, source_org_id: @ims_pre_header.source_org_id, source_org_name: @ims_pre_header.source_org_name, specialmark: @ims_pre_header.specialmark, status: @ims_pre_header.status, tookcode: @ims_pre_header.tookcode, total_amount: @ims_pre_header.total_amount, type_code: @ims_pre_header.type_code, type_name: @ims_pre_header.type_name } }
    end

    assert_redirected_to ims_pre_header_url(Ims::PreHeader.last)
  end

  test "should show ims_pre_header" do
    get ims_pre_header_url(@ims_pre_header)
    assert_response :success
  end

  test "should get edit" do
    get edit_ims_pre_header_url(@ims_pre_header)
    assert_response :success
  end

  test "should update ims_pre_header" do
    patch ims_pre_header_url(@ims_pre_header), params: { ims_pre_header: { address: @ims_pre_header.address, age: @ims_pre_header.age, audit_at: @ims_pre_header.audit_at, auditor_id: @ims_pre_header.auditor_id, auditor_name: @ims_pre_header.auditor_name, author_id: @ims_pre_header.author_id, author_name: @ims_pre_header.author_name, birth_date: @ims_pre_header.birth_date, charge_at: @ims_pre_header.charge_at, charger_id: @ims_pre_header.charger_id, charger_name: @ims_pre_header.charger_name, confidentiality_code: @ims_pre_header.confidentiality_code, confidentiality_name: @ims_pre_header.confidentiality_name, create_bill_opt_id: @ims_pre_header.create_bill_opt_id, create_bill_opt_name: @ims_pre_header.create_bill_opt_name, delivery_at: @ims_pre_header.delivery_at, delivery_id: @ims_pre_header.delivery_id, delivery_name: @ims_pre_header.delivery_name, delivery_org_id: @ims_pre_header.delivery_org_id, delivery_org_name: @ims_pre_header.delivery_org_name, diagnoses: @ims_pre_header.diagnoses, drug_store_id: @ims_pre_header.drug_store_id, drug_store_name: @ims_pre_header.drug_store_name, effective_end: @ims_pre_header.effective_end, effective_start: @ims_pre_header.effective_start, encounter_loc_id: @ims_pre_header.encounter_loc_id, encounter_loc_name: @ims_pre_header.encounter_loc_name, gender_code: @ims_pre_header.gender_code, gender_name: @ims_pre_header.gender_name, hospital_prescription_at: @ims_pre_header.hospital_prescription_at, hospital_prescription_id: @ims_pre_header.hospital_prescription_id, iden: @ims_pre_header.iden, is_return: @ims_pre_header.is_return, name: @ims_pre_header.name, note: @ims_pre_header.note, occupation_code: @ims_pre_header.occupation_code, occupation_name: @ims_pre_header.occupation_name, order_at: @ims_pre_header.order_at, order_code: @ims_pre_header.order_code, order_id: @ims_pre_header.order_id, ori_code: @ims_pre_header.ori_code, ori_id: @ims_pre_header.ori_id, patient_no: @ims_pre_header.patient_no, phone: @ims_pre_header.phone, prescription_no: @ims_pre_header.prescription_no, reason: @ims_pre_header.reason, return_at: @ims_pre_header.return_at, return_id: @ims_pre_header.return_id, return_name: @ims_pre_header.return_name, return_org_id: @ims_pre_header.return_org_id, return_org_name: @ims_pre_header.return_org_name, source_org_id: @ims_pre_header.source_org_id, source_org_name: @ims_pre_header.source_org_name, specialmark: @ims_pre_header.specialmark, status: @ims_pre_header.status, tookcode: @ims_pre_header.tookcode, total_amount: @ims_pre_header.total_amount, type_code: @ims_pre_header.type_code, type_name: @ims_pre_header.type_name } }
    assert_redirected_to ims_pre_header_url(@ims_pre_header)
  end

  test "should destroy ims_pre_header" do
    assert_difference('Ims::PreHeader.count', -1) do
      delete ims_pre_header_url(@ims_pre_header)
    end

    assert_redirected_to ims_pre_headers_url
  end
end
