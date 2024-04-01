class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show edit update destroy ]

  # GET /rooms or /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1 or /rooms/1.json
  def show
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms or /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        #formato:
        #format.turbo_stream { render turbo_stream: turbo_stream.append(id, partial, locals)  }

        format.turbo_stream { render turbo_stream: turbo_stream.append('rooms', partial: 'shared/room', locals: {room: @room})  }
      else
        #formato: format.turbo_stream { render turbo_stream: turbo_stream.replace(id, partial, locals) }
        format.turbo_stream { render turbo_stream: turbo_stream.replace('room-form', partial: 'rooms/form', locals: {room: @room}) }

      end
    end
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace("room-#{@room.id}", partial: 'shared/room', locals: {room: @room})  }
      else
        format.html { render :edit, status: :unprocessable_entity }
        #format.turbo_stream { render turbo_stream: turbo_stream.replace("room-#{@room.id}", partial: 'rooms/form', locals: {room: @room}) }
      end
    end
  end

  # DELETE /rooms/1 or /rooms/1.json
  def destroy
    @room.destroy!

    respond_to do |format|
      format.html { redirect_to rooms_url, notice: "Room was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.require(:room).permit(:name)
    end
end
