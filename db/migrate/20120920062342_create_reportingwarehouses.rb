class CreateReportingwarehouses < ActiveRecord::Migration
  def change
    create_table :reportingwarehouses do |t|
      t.integer :agency_id
      t.integer :generalagency_id
      t.integer :book_month
      t.integer :book_year
      t.integer :new_business_count
      t.integer :renewal_count
      t.integer :edorsement_count
      t.integer :cancellation_count
      t.timestamps
    end
  end
end
