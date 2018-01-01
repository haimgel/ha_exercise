
require 'json'
require 'rest-client'
require 'uri'

class ControlType < Sequel::Model

  plugin :validation_helpers
  many_to_one :device_type
  one_to_many :device_control_values

  SUPPORTED_KINDS = %w[button slider select].freeze
  SUPPORTED_REST_VERBS = %w[get post put patch delete].freeze

  def validate
    super
    validates_unique([:name, :device_type_id])
    errors.add(:name, 'cannot be empty') if !name || name.empty?
    errors.add(:kind, 'is not supported') unless SUPPORTED_KINDS.include?(kind.to_s)
    errors.add(:rest_verb, 'is not supported') unless SUPPORTED_REST_VERBS.include?(rest_verb.to_s) || rest_verb.nil?
    if kind == 'select'
      errors.add(:items, 'cannot be empty') unless selectable.select { |s| s.empty? }.empty?
      errors.add(:items, 'must be unique') unless selectable.uniq.length == selectable.length
    end
  end

  def selectable
    items ? JSON.parse(items) : ['']
  end

  def selectable=(arr)
    self.items = arr.to_json()
  end

  def button?
    kind == 'button'
  end

  def select?
    kind == 'select'
  end

  def slider?
    kind == 'slider'
  end

  def default_value
    case kind
    when 'select'
      selectable[0]
    when 'slider'
      # This 25% default volume is pretty arbitrary, but it looks nicer this way in the UI
      25
    else
      nil
    end
  end

  def send_rest(device, value)
    return true if rest_path.to_s.empty? || rest_verb.to_s.empty? || device.rest_url_prefix.to_s.empty?

    # This URI 'assembly' is questionable (no auto-adding of path delimiter, no default HTTP, etc.).
    # It is the most flexible, though.
    uri = device.rest_url_prefix + rest_path
    Log.info("Sending '#{rest_verb}' request to '#{uri}'")
    response = RestClient::Request.execute(method: rest_verb.upcase, url: uri, timeout: 10)
    Log.info("Got reply from '#{uri}': '#{response.to_s}'")
    # Request.execute raises exceptions, so it's safe to return true here
    true
  end

end
