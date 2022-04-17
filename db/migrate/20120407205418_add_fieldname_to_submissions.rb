class AddFieldnameToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :agent_id, :integer
    add_column :submissions, :quotetype, :string
    add_column :submissions, :deadline, :date
    add_column :submissions, :short_note, :string
  end
end
