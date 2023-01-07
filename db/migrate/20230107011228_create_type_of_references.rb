class CreateTypeOfReferences < ActiveRecord::Migration[5.2]
  def change
    create_table :type_of_references do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
