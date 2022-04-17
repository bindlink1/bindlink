class CreateMessageTemplate < ActiveRecord::Migration
  def change
    create_table :message_templates do |t|
      t.string :name
      t.string :content
    end
  end
end
