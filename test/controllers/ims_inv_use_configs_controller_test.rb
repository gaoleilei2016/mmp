require 'test_helper'

class ImsInvUseConfigsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ims_inv_use_config = ims_inv_use_configs(:one)
  end

  test "should get index" do
    get ims_inv_use_configs_url
    assert_response :success
  end

  test "should get new" do
    get new_ims_inv_use_config_url
    assert_response :success
  end

  test "should create ims_inv_use_config" do
    assert_difference('ImsInvUseConfig.count') do
      post ims_inv_use_configs_url, params: { ims_inv_use_config: { config: @ims_inv_use_config.config, use_system: @ims_inv_use_config.use_system } }
    end

    assert_redirected_to ims_inv_use_config_url(ImsInvUseConfig.last)
  end

  test "should show ims_inv_use_config" do
    get ims_inv_use_config_url(@ims_inv_use_config)
    assert_response :success
  end

  test "should get edit" do
    get edit_ims_inv_use_config_url(@ims_inv_use_config)
    assert_response :success
  end

  test "should update ims_inv_use_config" do
    patch ims_inv_use_config_url(@ims_inv_use_config), params: { ims_inv_use_config: { config: @ims_inv_use_config.config, use_system: @ims_inv_use_config.use_system } }
    assert_redirected_to ims_inv_use_config_url(@ims_inv_use_config)
  end

  test "should destroy ims_inv_use_config" do
    assert_difference('ImsInvUseConfig.count', -1) do
      delete ims_inv_use_config_url(@ims_inv_use_config)
    end

    assert_redirected_to ims_inv_use_configs_url
  end
end
