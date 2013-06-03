class ProjectsController < ApplicationController

  hobo_model_controller

  auto_actions :show, :edit, :update, :destroy

  auto_actions_for :owner, [:new, :create]

  def show
    @project = find_instance
    @stories = @project.stories.
      search(params[:search], :title).
      order_by(parse_sort_param(:title, :status))
    @stories = @stories.status_is(params[:status]) if params[:status] && !params[:status].blank?
    hobo_show
  end

end
