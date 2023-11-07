class AddTimestampsToItems < ActiveRecord::Migration
  def change
    add_timestamps :items, null: true
  end
end
