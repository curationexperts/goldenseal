class RightsController < ApplicationController
  authorize_resource class: "Qa::LocalAuthorityEntry"
  before_action :set_right, only: [:show, :edit, :update, :destroy]

  # GET /rights
  # GET /rights.json
  def index
    authority = Qa::LocalAuthority.where(name: 'rights').first
    @rights = authority.local_authority_entries
  end

  # GET /rights/1
  # GET /rights/1.json
  def show
  end

  # GET /rights/new
  def new
    authority = Qa::LocalAuthority.where(name: 'rights').first
    @right = authority.local_authority_entries.new
  end

  # GET /rights/1/edit
  def edit
  end

  # POST /rights
  # POST /rights.json
  def create
    authority = Qa::LocalAuthority.where(name: 'rights').first
    @right = authority.local_authority_entries.new(right_params)

    respond_to do |format|
      if @right.save
        format.html { redirect_to rights_path, notice: 'Right was successfully created.' }
        format.json { render :show, status: :created, location: @right }
      else
        format.html { render :new }
        format.json { render json: @right.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rights/1
  # PATCH/PUT /rights/1.json
  def update
    respond_to do |format|
      if @right.update(right_params)
        format.html { redirect_to rights_path, notice: 'Right was successfully updated.' }
        format.json { render :show, status: :ok, location: @right }
      else
        format.html { render :edit }
        format.json { render json: @right.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rights/1
  # DELETE /rights/1.json
  def destroy
    @right.destroy
    respond_to do |format|
      format.html { redirect_to rights_path, notice: 'Right was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_right
      @right = Qa::LocalAuthorityEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def right_params
      params[:local_authority_entry].permit(:local_authority_id, :label, :uri)
    end
end
