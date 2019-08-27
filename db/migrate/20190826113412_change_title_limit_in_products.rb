class ChangeTitleLimitInProducts < ActiveRecord::Migration[5.2]
  def up
    change_column :products, :title, :string, :limit => 70
  end

  def down
    change_column :products, :title, :string
  end
end
