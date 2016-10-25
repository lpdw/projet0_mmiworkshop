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

class FeaturesController < ApplicationController
  authorize_resource

  before_action :set_feature, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /features
  def index
    @fields = Field.all.where(parent_id: nil)
  end

  def synthesis
    @features = Feature.all
    @projects = Project.all
  end

  # GET /features/1
  def show
    @projects = Project.all
  end

  # GET /features/new
  def new
    @feature = Feature.new
  end

  # GET /features/1/edit
  def edit
  end

  # POST /features
  def create
    @feature = Feature.new(feature_params)

    if @feature.save
      redirect_to @feature, notice: 'Feature was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /features/1
  def update
    if @feature.update(feature_params)
      redirect_to @feature, notice: 'Feature was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /features/1
  def destroy
    @feature.destroy
    redirect_to features_url, notice: 'Feature was successfully destroyed.'
  end

  def autocomplete_feature
    if params[:term]
       @features_list = Feature.where('name ILIKE ?', "%#{params[:term].downcase}%")
       respond_to do |format|  
          format.html
          format.json { render :json => @features_list.as_json(:only => [:id], :methods => [:name_with_category]) }
       end
     end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feature
      @feature = Feature.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def feature_params
      params.require(:feature).permit(:name, :description, :icon, :position, :field_id, :level)
    end
end
