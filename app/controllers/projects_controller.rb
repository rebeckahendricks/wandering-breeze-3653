class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
    @challenge = @project.challenge
    if params[:add_contestant]
      ContestantProject.create(contestant_id: params[:add_contestant], project_id: @project.id)
    end
  end
end
