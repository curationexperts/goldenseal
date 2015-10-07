class DateService

  # Try to cast a date String to a DateTime, or at least format
  # the String.  If the date can't be parsed, just return the
  # original value.
  #
  # @param [String, DateTime, Date] A date
  # @return [DateTime, String] The cast or formatted date
  def self.parse(date)
    return if date.blank?
    return date if date.is_a?(DateTime) || date.is_a?(Date)

    date = date.strip if date.respond_to?(:strip)
    return date if is_a_year?(date)

    DateTime.parse(date).utc
  rescue
    date
  end

  def self.is_a_year?(date)
    four_digit_year = %r{^\d{4}\z}
    !date.match(four_digit_year).nil?
  end

end
