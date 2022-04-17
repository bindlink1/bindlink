class CreateOnlinequotes < ActiveRecord::Migration
  def change
    create_table :onlinequotes do |t|
      t.string :named_insured
      t.timestamps
    end
  end
end
