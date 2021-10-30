class RemoveBookIdFromChats < ActiveRecord::Migration[5.2]
  def change
    remove_column :chats, :book_id, :integer
  end
end
