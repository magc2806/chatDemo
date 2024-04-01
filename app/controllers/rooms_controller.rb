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
    @room.users << current_user

    if @room.save
      respond_to do |format|
        #formato:
        #format.turbo_stream { render turbo_stream: turbo_stream.append(id, partial, locals)  }

        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append('rooms', partial: 'shared/room', locals: { room: @room }),
            turbo_stream.replace(Room.new, partial: 'shared/create_room')]
        end
      end
    else
      render :new, status: :unprocessable_entity
      #formato: format.turbo_stream { render turbo_stream: turbo_stream.replace(id, partial, locals) }
      #format.turbo_stream { render turbo_stream: turbo_stream.replace('room-form', partial: 'rooms/form', locals: {room: @room}) }
    end
  end

  # PATCH/PUT /rooms/1 or /rooms/1.json
  def update
    if @room.update(room_params)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@room, partial: 'shared/room', locals: {room: @room})  }
      end
    else
      render :edit, status: :unprocessable_entity
      #format.turbo_stream { render turbo_stream: turbo_stream.replace("room-#{@room.id}", partial: 'rooms/form', locals: {room: @room}) }
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

  def add_user
    UserRoom.create(room_id: params[:room_id], user_id: params[:user_id])

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("room_show_#{params[:room_id]}", partial: 'rooms/room', locals: {room: Room.find(params[:room_id])})  }
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
