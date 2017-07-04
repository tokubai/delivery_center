create_table "deploys", unsigned: true, force: :cascade do |t|
  t.integer  :application_id, null: false
  t.integer  :revision_id, null: false
  t.boolean :current, default: false
  t.timestamps
end
