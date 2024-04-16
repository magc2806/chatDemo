# == Schema Information
#
# Table name: rooms
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Room < ApplicationRecord
  has_many :user_rooms, dependent: :destroy
  has_many :users, through: :user_rooms

  validates :name, presence: :true

  after_update_commit :update_room_details

  def update_room_details
    broadcast_replace_to('room_details_channel', partial: 'shared/room', locals: { room: self }, target: "room_#{id}" )
  end
end
