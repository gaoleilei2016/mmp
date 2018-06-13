class AddPhotoToPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :photo, :string
  end
end
