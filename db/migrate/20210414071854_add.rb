class Add < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :header, :string
  end
end
