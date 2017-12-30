

class Device < Sequel::Model

  plugin :validation_helpers
  many_to_one :device_type
  one_to_many :device_control_values

  def validate
    super
    errors.add(:name, 'cannot be empty') if !name || name.empty?
    validates_unique([:name])
  end

  def controls
    device_type.control_types
  end

  def control(id)
    controls.select { |c| c.id == id.to_i }.first
  end

  def get_value(control)
    value = DeviceControlValue.get_value(self, control)
    if value
      case control.kind
      when 'slider'
        value.to_i
      else
        value
      end
    end
  end

  def set_value(control, value)
    begin
      control.send_rest(self, value)
      DeviceControlValue.set_value(self, control, value.to_s)
      # All is well, send current value
      WebsocketCollection.send(self, control, value) unless value.nil?
    rescue StandardError
      # Error, send last known value
      WebsocketCollection.send(self, control, get_value(control)) unless value.nil?
      # Propagate error further into router
      raise
    end
  end

end

