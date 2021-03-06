class ChirpsController < ApplicationController
  
  before_action :set_chirp, only: [:show, :edit, :update, :destroy, :upvote]
  before_action :authenticate_user!, except: [:index, :show]

  # GET /chirps
  # GET /chirps.json
  def index
    if current_user
    else 
      redirect_to new_user_session_path
    end
  end

  # GET /chirps/1
  # GET /chirps/1.json
  def show
    @chirps = current_user.chirps
  end

  # GET /chirps/new
  def new
    @chirp = current_user.chirps.build
  end

  # GET /chirps/1/edit
  def edit
  end

  # POST /chirps
  # POST /chirps.json
  def create
    @chirp = current_user.chirps.build(chirp_params)

    respond_to do |format|
      if @chirp.save
        format.html { redirect_to root_path, notice: 'Chirp was successfully created.' }
        format.json { render :show, status: :created, location: @chirp }
      else
        format.html { render :new }
        format.json { render json: @chirp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chirps/1
  # PATCH/PUT /chirps/1.json
  def update
    respond_to do |format|
      if @chirp.update(chirp_params)
        format.html { redirect_to @chirp, notice: 'Chirp was successfully updated.' }
        format.json { render :show, status: :ok, location: @chirp }
      else
        format.html { render :edit }
        format.json { render json: @chirp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chirps/1
  # DELETE /chirps/1.json
  def destroy
    @chirp.destroy
    respond_to do |format|
      format.html { redirect_to chirps_url, notice: 'Chirp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote 
    @chirp = Chirp.find(params[:id])
    @chirp.upvote_by current_user
    redirect_back(fallback_location: root_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chirp
      @chirp = Chirp.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chirp_params
      params.require(:chirp).permit(:chirp_text)
    end
end
