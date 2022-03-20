class AddUnlikeToLikeables < ActiveRecord::Migration[7.0]
  def change
    add_column :likeables, :unlike, :boolean, default: false
  end
end
