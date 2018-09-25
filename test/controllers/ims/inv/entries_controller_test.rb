require 'test_helper'

class Ims::Inv::EntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ims_inv_entry = ims_inv_entries(:one)
  end

  test "should get index" do
    get ims_inv_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_ims_inv_entry_url
    assert_response :success
  end

  test "should create ims_inv_entry" do
    assert_difference('Ims::Inv::Entry.count') do
      post ims_inv_entries_url, params: { ims_inv_entry: { amount: @ims_inv_entry.amount, batch: @ims_inv_entry.batch, code: @ims_inv_entry.code, created_at: @ims_inv_entry.created_at, document_code: @ims_inv_entry.document_code, document_id: @ims_inv_entry.document_id, document_line_id: @ims_inv_entry.document_line_id, entry_type: @ims_inv_entry.entry_type, formul_name: @ims_inv_entry.formul_name, location_id: @ims_inv_entry.location_id, location_name: @ims_inv_entry.location_name, medicine_id: @ims_inv_entry.medicine_id, mul: @ims_inv_entry.mul, name: @ims_inv_entry.name, note: @ims_inv_entry.note, operat_at: @ims_inv_entry.operat_at, operater: @ims_inv_entry.operater, operater_id: @ims_inv_entry.operater_id, org_id: @ims_inv_entry.org_id, patient_name: @ims_inv_entry.patient_name, posting_on: @ims_inv_entry.posting_on, price: @ims_inv_entry.price, pt_code: @ims_inv_entry.pt_code, quantity: @ims_inv_entry.quantity, source_id: @ims_inv_entry.source_id, source_name: @ims_inv_entry.source_name, spec: @ims_inv_entry.spec, unit: @ims_inv_entry.unit, updated_at: @ims_inv_entry.updated_at } }
    end

    assert_redirected_to ims_inv_entry_url(Ims::Inv::Entry.last)
  end

  test "should show ims_inv_entry" do
    get ims_inv_entry_url(@ims_inv_entry)
    assert_response :success
  end

  test "should get edit" do
    get edit_ims_inv_entry_url(@ims_inv_entry)
    assert_response :success
  end

  test "should update ims_inv_entry" do
    patch ims_inv_entry_url(@ims_inv_entry), params: { ims_inv_entry: { amount: @ims_inv_entry.amount, batch: @ims_inv_entry.batch, code: @ims_inv_entry.code, created_at: @ims_inv_entry.created_at, document_code: @ims_inv_entry.document_code, document_id: @ims_inv_entry.document_id, document_line_id: @ims_inv_entry.document_line_id, entry_type: @ims_inv_entry.entry_type, formul_name: @ims_inv_entry.formul_name, location_id: @ims_inv_entry.location_id, location_name: @ims_inv_entry.location_name, medicine_id: @ims_inv_entry.medicine_id, mul: @ims_inv_entry.mul, name: @ims_inv_entry.name, note: @ims_inv_entry.note, operat_at: @ims_inv_entry.operat_at, operater: @ims_inv_entry.operater, operater_id: @ims_inv_entry.operater_id, org_id: @ims_inv_entry.org_id, patient_name: @ims_inv_entry.patient_name, posting_on: @ims_inv_entry.posting_on, price: @ims_inv_entry.price, pt_code: @ims_inv_entry.pt_code, quantity: @ims_inv_entry.quantity, source_id: @ims_inv_entry.source_id, source_name: @ims_inv_entry.source_name, spec: @ims_inv_entry.spec, unit: @ims_inv_entry.unit, updated_at: @ims_inv_entry.updated_at } }
    assert_redirected_to ims_inv_entry_url(@ims_inv_entry)
  end

  test "should destroy ims_inv_entry" do
    assert_difference('Ims::Inv::Entry.count', -1) do
      delete ims_inv_entry_url(@ims_inv_entry)
    end

    assert_redirected_to ims_inv_entries_url
  end
end
