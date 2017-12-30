
require 'json'

module WebsocketCollection

  @@sockets = {}

  def self.add(ws, device)
    @@sockets[ws] = device.id
  end

  def self.remove(ws)
    @@sockets.delete(ws)
  end

  def self.send(device, control, value)
    @@sockets.each do |ws, device_id|
      ws.send(JSON.generate({device: device.id, control: control.id, value: value})) if device.id == device_id
    end
  end

end
