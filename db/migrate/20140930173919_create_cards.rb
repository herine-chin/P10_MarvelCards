class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.belongs_to :user
      t.integer :char_id
      t.string :name
      t.string :image
      t.text :description
      t.boolean :accepted, default: false
      t.timestamps
    end
  end
end
