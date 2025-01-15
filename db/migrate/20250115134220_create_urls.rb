class CreateUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :urls do |t|
      t.string :url_original
      t.string :url_shortener
      t.integer :visits, default: 0
      t.string :page_title

      t.timestamps
    end
    add_index :urls, :url_shortener, unique:true
  end
end
