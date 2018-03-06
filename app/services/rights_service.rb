module RightsService
  mattr_accessor :authority
  self.authority = Qa::Authorities::Local.subauthority_for('rights')

  def self.select_options
    authority.all.map do |element|
      [element[:label], element[:id]]
    end
  end

  def self.label(id)
    record = authority.find(id)
    record.fetch(:label) if record
  end
end
