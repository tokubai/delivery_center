create_table "applications", unsigned: true, force: :cascade do |t|
  t.string :name, null: false
  t.timestamps
end

add_index "applications", ["name"], name: "idx_name", unique: true, using: :btree
