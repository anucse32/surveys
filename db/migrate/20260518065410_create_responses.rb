class CreateResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :responses do |t|
      t.references :survey, null: false, foreign_key: { on_delete: :cascade }
      t.boolean :answer, null: false
      t.timestamps
    end
  end
end
