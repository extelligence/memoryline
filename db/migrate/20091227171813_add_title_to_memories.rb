class AddTitleToMemories < ActiveRecord::Migration
  def self.up
    add_column :memories, :title, :string, :null => false
  end

  def self.down
    remove_column :memories, :title
  end
end
