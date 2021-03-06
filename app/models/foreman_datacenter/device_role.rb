module ForemanDatacenter
  class DeviceRole < ActiveRecord::Base
    COLORS = [
        'Teal', 'Green', 'Blue', 'Purple', 'Yellow', 'Orange', 'Red',
        'Light Gray', 'Medium Gray', 'Dark Gray'
    ].freeze

    has_many :devices, :class_name => 'ForemanDatacenter::Device'

    validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
    validates :color, presence: true, length: { maximum: 30 },
              inclusion: { in: COLORS, message: "Color must be one of #{COLORS.join(', ')}"}

    def self.for_host
      role = find_by_name('Server')
      if role
        role
      else
        create!(name: 'Server', color: 'Green')
      end
    end
  end
end
