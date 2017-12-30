
class App < Roda

  def websocket_handler(device, ws)

    ws.on :open do |event|
      Log.debug("Opening websocket from #{ws.env['REMOTE_ADDR']}")
      WebsocketCollection.add(ws, device)
    end

    ws.on :message do |event|
      Log.warn("Received message on websocket from #{ws.env['REMOTE_ADDR']} (shouldn't happen)")
    end

    ws.on :close do |event|
      Log.debug("Closing websocket from #{ws.env['REMOTE_ADDR']}")
      WebsocketCollection.remove(ws)
    end

    ws.rack_response
  end

end

