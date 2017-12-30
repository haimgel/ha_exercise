
class App < Roda

  route('devices') do |r|

    r.is do
      # /devices
      r.get do
        view('devices', locals: { title: 'devices', devices: Device.all })
      end
    end

    r.is Integer do |id|

      @device = Device[id]

      # GET /devices/1
      # Show one specific device, with controls
      r.get do
        view('device', locals: { device: @device }) if @device
      end

      # POST /devices/1?control=2
      # Update value of one specific control
      r.post do
        control = @device.control(params[:control])
        if control
          begin
            @device.set_value(control, params[:value])
            { success: true }
          rescue StandardError => e
            response.status = 409
            { success: false, error: e.message }
          end
        end
      end
    end
  end

end
