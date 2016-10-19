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

class FieldsController < ApplicationController
  authorize_resource

  before_action :set_field, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /fields
  def index
    @fields = Field.all
  end

  # GET /fields/1
  def show
  end

  # GET /fields/new
  def new
    @field = Field.new
  end

  # GET /fields/1/edit
  def edit
  end

  # POST /fields
  def create
    @field = Field.new(field_params)

    if @field.save
      redirect_to fields_url, notice: 'Field was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /fields/1
  def update
    if @field.update(field_params)
      redirect_to fields_url, notice: 'Field was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /fields/1
  def destroy
    @field.destroy
    redirect_to fields_url, notice: 'Field was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_field
      @field = Field.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def field_params
      params.require(:field).permit(:name, :color, :position, :parent_id, :icon)
    end
end
