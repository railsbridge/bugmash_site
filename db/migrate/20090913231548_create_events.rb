class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |table|
      table.string  :name
      table.boolean :current, :default => false
      table.timestamps
    end

  end

  def self.down
    drop_table :events
  end
end
