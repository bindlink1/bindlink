class Addremindertonote < ActiveRecord::Migration
  def up
    add_column :notes, :reminder_date, :date
  end

  def down
  end
end
