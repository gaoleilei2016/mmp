require 'test_helper'

class Ims::Inv::SelectConfigsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ims_inv_select_config = ims_inv_select_configs(:one)
  end

  test "should get index" do
    get ims_inv_select_configs_url
    assert_response :success
  end

  test "should get new" do
    get new_ims_inv_select_config_url
    assert_response :success
  end

  test "should create ims_inv_select_config" do
    assert_difference('Ims::Inv::SelectConfig.count') do
      post ims_inv_select_configs_url, params: { ims_inv_select_config: { c_id: @ims_inv_select_config.c_id, use_name: @ims_inv_select_config.use_name, use_org_id: @ims_inv_select_config.use_org_id } }
    end

    assert_redirected_to ims_inv_select_config_url(Ims::Inv::SelectConfig.last)
  end

  test "should show ims_inv_select_config" do
    get ims_inv_select_config_url(@ims_inv_select_config)
    assert_response :success
  end

  test "should get edit" do
    get edit_ims_inv_select_config_url(@ims_inv_select_config)
    assert_response :success
  end

  test "should update ims_inv_select_config" do
    patch ims_inv_select_config_url(@ims_inv_select_config), params: { ims_inv_select_config: { c_id: @ims_inv_select_config.c_id, use_name: @ims_inv_select_config.use_name, use_org_id: @ims_inv_select_config.use_org_id } }
    assert_redirected_to ims_inv_select_config_url(@ims_inv_select_config)
  end

  test "should destroy ims_inv_select_config" do
    assert_difference('Ims::Inv::SelectConfig.count', -1) do
      delete ims_inv_select_config_url(@ims_inv_select_config)
    end

    assert_redirected_to ims_inv_select_configs_url
  end
end
