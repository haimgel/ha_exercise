
Sequel.migration do

  up do
    create_table(:device_types) do
      primary_key :id
      String :name, null: false, unique: true
    end

    create_table(:control_types) do
      primary_key :id
      foreign_key :device_type_id, :device_types, on_delete: :cascade
      String :name, null: false
      String :kind, null: false
      String :rest_path
      String :rest_verb
      String :items, text: true
    end

    create_table(:devices) do
      primary_key :id
      foreign_key :device_type_id, :device_types, on_delete: :cascade
      String :name, null: false, unique: true
      String :rest_url_prefix
    end

    create_table(:device_control_values) do
      primary_key :id
      foreign_key :device_id, :devices, on_delete: :cascade
      foreign_key :control_type_id, :control_types, on_delete: :cascade
      String :value, null: false
    end

  end

  down do
    drop_table :device_control_values
    drop_table :devices
    drop_table :control_types
    drop_table :device_types
  end

end
