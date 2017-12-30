
class App < Roda

  route('admin', 'devices') do |r|

    r.is do
      # /admin/devices
      r.get do
        view('admin/devices', locals: { devices: Device.all })
      end
    end

    # /admin/devices/new
    r.get 'new' do
      view('admin/device', locals: {device: Device.new, device_types: DeviceType.all })
    end

    # /admin/devices/new (create)
    r.post 'new' do
      device = Device.new(params[:device])
      if device.valid?
        device.save
        flash[:success] = 'Device created successfully'
        r.redirect '/admin/devices'
      else
        flash.now[:error] = device.errors.full_messages
        view('admin/device', locals: { device: device, device_types: DeviceType.all })
      end
    end

    r.on Integer do |id|

      @device = Device[id]

      # /admin/devices/1/show
      r.get 'show' do
        view('device', locals: {device: @device, device_types: DeviceType.all }) if @device
      end

      # /admin/devices/1
      r.get do
        view('admin/device', locals: {device: @device, device_types: DeviceType.all }) if @device
      end

      # /admin/devices/1 (update)
      r.put do
        if @device
          @device.set(params[:device])
          if @device.valid?
            @device.save
            flash[:success] = 'Device saved successfully'
            r.redirect '/admin/devices'
          else
            flash.now[:error] = @device.errors.full_messages
            view('admin/device', locals: { device: @device, device_types: DeviceType.all })
          end
        end
      end

      # # /admin/devices/1 (delete)
      r.delete do
        if @device
          @device.destroy
          flash[:success] = 'Device deleted successfully'
          r.redirect '/admin/devices'
        end
      end
    end
  end

end
