
require 'json'

Sequel.migration do

  up do
    from(:device_types).insert(id: 1, name: 'Samsung Audio')
    from(:device_types).insert(id: 2, name: 'Sony Audio')
    from(:device_types).insert(id: 3, name: 'Apple TV')
    from(:device_types).insert(id: 4, name: 'Citrus Lights')

    from(:control_types).insert(id: 1, device_type_id: 1, name: 'Power', kind: 'button', items: nil)
    from(:control_types).insert(id: 2, device_type_id: 1, name: 'Volume', kind: 'slider', items: nil,
      rest_path: '/not-exists', rest_verb: 'put')
    from(:control_types).insert(id: 3, device_type_id: 1, name: 'Playlist', kind: 'select',
      items: ['Samsung sad song', 'Samsung happy song', 'Samsung really lond and boring song'].to_json)
    from(:control_types).insert(id: 4, device_type_id: 2, name: 'Power', kind: 'button', items: nil)
    from(:control_types).insert(id: 5, device_type_id: 2, name: 'Volume', kind: 'slider', items: nil)
    from(:control_types).insert(id: 6, device_type_id: 2, name: 'Playlist', kind: 'select',
      items: ['Sony marry song', 'Sony happy song', 'Sony short and quiet song'].to_json)
    from(:control_types).insert(id: 7, device_type_id: 3, name: 'Power', kind: 'button', items: nil)
    from(:control_types).insert(id: 8, device_type_id: 3, name: 'Volume', kind: 'slider', items: nil)
    from(:control_types).insert(id: 9, device_type_id: 3, name: 'Brightness', kind: 'slider', items: nil)
    from(:control_types).insert(id: 10, device_type_id: 4, name: 'On/Off', kind: 'button', items: nil,
      rest_path: 'citrus-light/power', rest_verb: 'post')

    from(:devices).insert(id: 1, name: 'Bedroom Apple TV',  device_type_id: 3)
    from(:devices).insert(id: 2, name: 'Livingroom Player', rest_url_prefix: 'http://nonexistent.host/', device_type_id: 1)
    from(:devices).insert(id: 3, name: 'Livingroom Lights', rest_url_prefix: 'http://automation-prototype.herokuapp.com/', device_type_id: 4)
  end

  down do
    from(:control_types).delete()
    from(:device_types).delete()
  end

end
