
class DeviceControlValue < Sequel::Model

  many_to_one :control_types
  many_to_one :devices

  def self.set_value(device, control_type, value)
    # Button state is not persisted
    return nil if control_type.button?
    record = first(control_type_id: control_type.id, device_id: device.id)
    if record
      if value.nil?
        record.destroy
      else
        record.value = value
        record.save
      end
    else
      insert(control_type_id: control_type.id, device_id: device.id, value: value) unless value.nil?
    end
  end

  def self.get_value(device, control_type)
    return nil if control_type.button?
    record = first(control_type_id: control_type.id, device_id: device.id)
    if record
      record.value
    else
      control_type.default_value
    end
  end

end
