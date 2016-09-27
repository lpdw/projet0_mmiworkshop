# == Schema Information
#
# Table name: fields
#
#  id         :integer          not null, primary key
#  name       :string
#  color      :string
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  icon       :string
#  parent_id  :integer
#

require 'test_helper'

class FieldsControllerTest < ActionController::TestCase
  setup do
    @field = fields(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create field" do
    assert_difference('Field.count') do
      post :create, field: { color: @field.color, name: @field.name, position: @field.position }
    end

    assert_redirected_to field_path(assigns(:field))
  end

  test "should show field" do
    get :show, id: @field
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @field
    assert_response :success
  end

  test "should update field" do
    patch :update, id: @field, field: { color: @field.color, name: @field.name, position: @field.position }
    assert_redirected_to field_path(assigns(:field))
  end

  test "should destroy field" do
    assert_difference('Field.count', -1) do
      delete :destroy, id: @field
    end

    assert_redirected_to fields_path
  end
end
