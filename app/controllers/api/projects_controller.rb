class Api::ProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_project, only: %i[show edit update destroy]

  # GET /projects
  def index
    @projects = Project.all
    respond_to do |format|
      format.html
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  def show
    respond_to do |format|
      format.html
      format.json { render json: @project }
    end
  end

  def new
    @project = Project.new
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      respond_to do |format|
        format.html { redirect_to api_projects_path }
        format.json { render json: @project, status: :created, location: @project }
      end
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def edit
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      respond_to do |format|
        format.html { redirect_to api_projects_path }
        format.json { render json: @project }
      end
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1
  def destroy
    if @project.destroy
      respond_to do |format|
        format.html { redirect_to api_projects_path }
      end
    end
  end

  # GET /projects/1/members
  def members
    @project = Project.find(params[:project_id])
    @members = @project.members

    render json: @members
  end

  def add_project_member
    sql ="
      SELECT m.id FROM members m
      LEFT JOIN project_members pm on m.id = pm.member_id AND pm.project_id = :project_id
      WHERE pm.id IS NULL
    "

    @project = Project.find(params[:project_id])
    members = ActiveRecord::Base.connection.select_all(
      ApplicationRecord.sanitize_sql_for_assignment([sql, project_id: params[:project_id]])
    )
    @available_members = Member.where(id: members.pluck('id'))
  end

  def create_project_member
    @project = Project.find(params[:project_id])
    @member = Member.find(params[:id])

    @project_member = ProjectMember.new
    @project_member.project = @project
    @project_member.member = @member

    if @project_member.save
      respond_to do |format|
        format.html { redirect_to api_projects_path }
        format.json { render json: Project.find(params[:project_id]).members }
      end
    end
  end

  # Callbacks
  def set_project
    @project = Project.find(params[:id])
  end

  # Trusted Parameters
  def project_params
    params.require(:project).permit(:name)
  end
end
