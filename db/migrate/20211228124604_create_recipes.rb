class CreateRecipes < ActiveRecord::Migration[6.0]
  def change
    create_table :recipes do |t|
      t.string    :name
      t.string    :description
      t.integer   :rating
      t.string    :img_url
      t.boolean   :done
      t.references  :user, foreign_key: true
      t.timestamps # add 2 columns, `created_at` and `updated_at`
    end
  end
end
