class AddPictureToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :picture, :string
  end
end
