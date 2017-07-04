create_table "revisions", unsigned: true, force: :cascade do |t|
  t.integer :application_id, null: false
  t.string  :value, null: false
  t.timestamps
end

add_index "revisions", ["application_id", "value"], name: "idx_application_id_value", unique: true, using: :btree
