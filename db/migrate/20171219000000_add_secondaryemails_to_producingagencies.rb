class AddSecondaryemailsToProducingagencies < ActiveRecord::Migration
  def up
    add_column :producingagencies, :secondary_emails, :string
  end

  def down
  end
end
