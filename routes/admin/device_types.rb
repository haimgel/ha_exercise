
class App < Roda

  route('admin', 'device_types') do |r|

    r.is do
      # View all device types
      r.get do
        device_types = DeviceType.all
        view('admin/device_types', locals: { device_types: device_types })
      end
    end

    # /admin/device_types/new
    r.get 'new' do
      view('admin/device_type', locals: {device_type: DeviceType.new })
    end

    # /admin/devices/new (create)
    r.post 'new' do
      device_type = DeviceType.new
      begin
        DB.transaction do
          device_type.name = params[:device_type][:name]
          device_type.control_types_attributes = params[:device_type][:control_types] if params[:device_type][:control_types]
          device_type.save
          flash[:success] = 'Device type created successfully'
          r.redirect '/admin/device_types'
        end
      rescue Sequel::ValidationFailed
        device_type.id = nil
        flash.now[:error] = device_type.errors.full_messages + device_type.control_types.map{ |ct| ct.errors.full_messages }.flatten
        view('admin/device_type', locals: { device_type: device_type })
      end
    end

    r.is Integer do |id|

      @device_type = DeviceType[id]

      # /admin/device_types/1
      r.get do
        view('admin/device_type', locals: { device_type: @device_type })
      end

      # /admin/device_types/1 (update)
      r.put do
        begin
          DB.transaction do
            @device_type.name = params[:device_type][:name]
            @device_type.control_types_dataset.destroy
            @device_type.control_types_attributes = params[:device_type][:control_types] if params[:device_type][:control_types]
            @device_type.save
            flash[:success] = 'Device type saved successfully'
            r.redirect '/admin/device_types'
          end
        rescue Sequel::ValidationFailed
          flash.now[:error] = @device_type.errors.full_messages + @device_type.control_types.map{ |ct| ct.errors.full_messages }.flatten
          response.write(view('admin/device_type', locals: { device_type: @device_type }))
        end
      end

      # /admin/device_types/1 (delete)
      r.delete do
        if @device_type
          @device_type.destroy
          flash[:success] = 'Device type deleted successfully'
          r.redirect '/admin/device_types'
        end
      end
    end
  end

end