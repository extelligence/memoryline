class Memory < ActiveRecord::Base
  acts_as_graph

  belongs_to :user

  validates_presence_of :content
  validates_length_of :content, :maximum => 255

  # MemoryForm Suggest User Index
  def self.my_memory_index(current_user_id)
    Memory.find(:all,
                :conditions => ["user_id = ?", current_user_id],
                :order => "created_at DESC")
  end

  def self.is_my_memory?(memory, current_user_id)
    record = Memory.find_by_content_and_user_id(memory['content'], current_user_id)
    if record.nil?
      record = Memory.create(memory)
    end

    record
  end

  def self.is_my_edge?(from, to, current_user_id)
    edge = MemoryEdge.find_by_from_id_and_to_id_and_user_id(from.id, to.id, current_user_id)
    unless edge
      edge = MemoryEdge.create(:from => from, :to => to, :user_id => current_user_id)
    end

    edge
  end
end
