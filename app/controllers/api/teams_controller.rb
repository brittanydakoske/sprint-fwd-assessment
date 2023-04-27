class Api::TeamsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_team, only: %i[show edit update destroy]

  # GET /teams
  def index
    @teams = Team.all
    respond_to do |format|
      format.html
      format.json { render json: @teams }
    end
  end

  # GET /teams/1
  def show
    respond_to do |format|
      format.html
      format.json { render json: @team.as_json(include: :members) }
    end
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # POST /teams
  def create
    @team = Team.new(team_params)
    if @team.save
      respond_to do |format|
        format.html { redirect_to api_teams_path }
        format.json { render json: @team, location: api_team_path(@team) }
      end
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # GET /teams/1/edit
  def edit
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      respond_to do |format|
        format.html { redirect_to api_teams_path }
        format.json { render json: @team, location: api_team_path(@team) }
      end
    else
      render json: @team.errors, status: :unprocessable_entity
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to api_teams_path }
    end
  end

  # GET /teams/1/members
  def members
    @team = Team.find(params[:team_id])
    @members = @team.members

    render json: @members
  end

  # Callbacks
  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name)
  end
end
