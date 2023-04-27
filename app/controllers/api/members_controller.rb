class Api::MembersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_member, only: %i[show edit update destroy update_project]

  # GET /members
  def index
    @members = Member.all
    respond_to do |format|
      format.html
      format.json { render json: @members }
    end
  end

  # GET /members/1
  def show
    respond_to do |format|
      format.html
      format.json { render json: @member, location: api_member_path(@member) }
    end
  end

  # GET /members/1/new
  def new
    @member = Member.new
  end

  # POST /members
  def create
    @member = Member.new(member_params)

    if @member.save
      respond_to do |format|
        format.html { redirect_to api_members_path }
        format.json { render json: @member, location: api_member_path(@member) }
      end
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # GET /members/1/edit
  def edit
  end

  # PATCH/PUT /members/1
  def update
    if @member.update(member_params)
      respond_to do |format|
        format.html { redirect_to api_members_path }
        format.json { render json: @members, location: api_members_path(@members) }
      end
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # DELETE /members/1
  def destroy
    if @member.destroy
      respond_to do |format|
        format.html { redirect_to api_members_path }
      end
    end
  end

  # PATCH /members/1/teams/1
  def update_team
    @member = Member.find(params[:member_id])
    @member.team_id = params[:id]
    if @member.save
      render json: @member
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # PATCH /projects/1/members/1
  def update_project
    @member.project_id = params[:id]
    if @member.save
      render json: @member
    else
      render json: @member.errors, status: :unprocessable_entity
    end
  end

  # Callbacks
  def set_member
    @member = Member.find(params[:id])
  end

  # Trusted Parameters
  def member_params
    params.require(:member).permit(
      :team_id,
      :first_name, :last_name,
      :city, :state, :country
    )
  end
end
