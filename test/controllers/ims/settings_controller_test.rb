require 'test_helper'

class Ims::SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ims_setting = ims_settings(:one)
  end

  test "should get index" do
    get ims_settings_url
    assert_response :success
  end

  test "should get new" do
    get new_ims_setting_url
    assert_response :success
  end

  test "should create ims_setting" do
    assert_difference('Ims::Setting.count') do
      post ims_settings_url, params: { ims_setting: { ii_root: @ims_setting.ii_root, payment_Expired: @ims_setting.payment_Expired, returned_at: @ims_setting.returned_at, unpaid_expired: @ims_setting.unpaid_expired } }
    end

    assert_redirected_to ims_setting_url(Ims::Setting.last)
  end

  test "should show ims_setting" do
    get ims_setting_url(@ims_setting)
    assert_response :success
  end

  test "should get edit" do
    get edit_ims_setting_url(@ims_setting)
    assert_response :success
  end

  test "should update ims_setting" do
    patch ims_setting_url(@ims_setting), params: { ims_setting: { ii_root: @ims_setting.ii_root, payment_Expired: @ims_setting.payment_Expired, returned_at: @ims_setting.returned_at, unpaid_expired: @ims_setting.unpaid_expired } }
    assert_redirected_to ims_setting_url(@ims_setting)
  end

  test "should destroy ims_setting" do
    assert_difference('Ims::Setting.count', -1) do
      delete ims_setting_url(@ims_setting)
    end

    assert_redirected_to ims_settings_url
  end
end
