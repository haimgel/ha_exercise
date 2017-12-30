
class DeviceType < Sequel::Model

  one_to_many :control_types
  one_to_many :devices

  plugin :validation_helpers
  plugin :nested_attributes
  nested_attributes :control_types, destroy: true, unmatched_pk: :create

  def validate
    super
    validates_unique([:name])
    errors.add(:name, 'cannot be empty') if !name || name.empty?
  end

end
