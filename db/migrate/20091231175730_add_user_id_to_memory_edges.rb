class AddUserIdToMemoryEdges < ActiveRecord::Migration
  def self.up
    add_column :memory_edges, :user_id, :integer, :null => false
  end

  def self.down
    remove_column :memory_edges, :user_id
  end
end
