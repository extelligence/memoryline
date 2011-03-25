class RemoveTitleToMemories < ActiveRecord::Migration
  def self.up
    remove_column :memories, :title
    change_column :memories, :content, :string, :null => false
  end

  def self.down
    add_column :memories, :title, :string, :null => false
    change_column :memories, :content, :text, :null => false
  end
end
