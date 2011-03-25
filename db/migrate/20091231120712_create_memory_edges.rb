class CreateMemoryEdges < ActiveRecord::Migration
  def self.up
    create_table :memory_edges do |t|
      t.column :from_id, :integer, :null => false
      t.column :to_id, :integer,:null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :memory_edges
  end
end
