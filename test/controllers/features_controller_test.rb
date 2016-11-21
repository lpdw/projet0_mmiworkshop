# == Schema Information
#
# Table name: features
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  icon        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  position    :integer
#  field_id    :integer
#  level       :integer
#

require 'test_helper'
#require 'factory_girl_rails'

class FeaturesControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

#  def setup
#    @request.env["devise.mapping"] = Devise.mappings[:admin]
#    sign_in FactoryGirl.create(:admin)
#  end

  setup do
    @feature = features(:one)
  end

#  test "should get index" do
#    get :index
#    assert_response :success
#    assert_not_nil assigns(:features)
#  end

#  test "should get new" do
#    get :new
#    assert_response :success
#  end

#   test "should create feature" do
#     assert_difference('Feature.count') do
#       post :create, feature: { description: @feature.description, icon: @feature.icon, name: @feature.name }
#     end

#     assert_redirected_to feature_path(assigns(:feature))
#   end

#   test "should show feature" do
#     get :show, id: @feature
#     assert_response :success
#   end

#   test "should get edit" do
#     get :edit, id: @feature
#     assert_response :success
#   end

#   test "should update feature" do
#     patch :update, id: @feature, feature: { description: @feature.description, icon: @feature.icon, name: @feature.name }
#     assert_redirected_to feature_path(assigns(:feature))
#   end

#   test "should destroy feature" do
#     assert_difference('Feature.count', -1) do
#       delete :destroy, id: @feature
#     end

#     assert_redirected_to features_path
#   end
end
