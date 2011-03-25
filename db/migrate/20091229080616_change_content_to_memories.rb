class ChangeContentToMemories < ActiveRecord::Migration
  def self.up
    change_column :memories, :content, :text, :null => false
  end

  def self.down
    change_column :memories, :content, :string, :null => false
  end
end
