class CreateMemories < ActiveRecord::Migration
  def self.up
    create_table :memories do |t|
      t.string :content, :null => false
      t.integer :user_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :memories
  end
end
