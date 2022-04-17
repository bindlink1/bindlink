class CreateTempdocs < ActiveRecord::Migration
  def change
    create_table :tempdocs do |t|
      t.string :clt_num
      t.string :pol_num
      t.integer :attach_seq
      t.string :file_desc
      t.string :file_type
      t.string :file_path
      t.date :created_date
      t.timestamps
    end
  end
end
