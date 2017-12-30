
class App < Roda

  route('admin') do |r|

    r.is do
      r.get do
        view('admin/index')
      end
    end

    r.on('devices') { r.route('admin', 'devices') }
    r.on('device_types') { r.route('admin', 'device_types') }
  end

end
