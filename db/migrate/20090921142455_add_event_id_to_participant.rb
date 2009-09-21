class AddEventIdToParticipant < ActiveRecord::Migration
  def self.up
    add_column :participants, :event_id, :integer
    add_index :participants, :event_id
  end

  def self.down
    remove_index :participants, :event_id
    remove_column :participants, :event_id
  end
end
