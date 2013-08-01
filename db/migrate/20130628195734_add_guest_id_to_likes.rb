class AddGuestIdToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :guest_id, :string
  end
end
