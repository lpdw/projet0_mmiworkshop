class DashboardController < ApplicationController

  # GET /projects
  def index
    @projects = Project.all
    @features = Feature.all
  end

  def synthesis
    @projects = Project.all
    @features = Feature.all
  end

  # GET /projects/1/stats
  def stats
    @projects= Project.all
  end

  # GET /projects/1/stats
  def statsDetails
    @project= Project.all
  end

end
