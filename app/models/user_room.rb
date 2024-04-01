# == Schema Information
#
# Table name: user_rooms
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  room_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room

  after_commit on: :create do
    broadcast_append_to(
      user,
      partial: 'shared/room',
      locals: { room: Room.find(room_id) },
      target: 'rooms'
    )
  end
end
