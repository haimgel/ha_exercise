
require 'json'

#
# This implementation if naive and supports single-instance web servers only (because the collection in held in
# module instance variable). This is just a proof of concept.
#
module WebsocketCollection

  @@sockets = {}

  def self.add(ws, device)
    @@sockets[ws] = device && device.id
  end

  def self.remove(ws)
    @@sockets.delete(ws)
  end

  def self.send(device, control, value)
    @@sockets.each do |ws, device_id|
      ws.send(JSON.generate({device: device.id, control: control.id, value: value})) if device_id.nil? || (device.id == device_id)
    end
  end

end
