create_table "api_keys", unsigned: true, force: :cascade do |t|
  t.string :title, null: false
  t.string :description, null: false
  t.string :value, null: false
  t.timestamps
end
