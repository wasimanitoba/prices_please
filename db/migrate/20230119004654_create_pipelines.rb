class CreatePipelines < ActiveRecord::Migration[7.0]
  def change
    create_table :pipelines do |t|
      t.string :target, null: false
      t.references :department, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.string :website, null: false

      t.timestamps
    end
  end
end
