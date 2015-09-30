module CurationConcerns
  module CommonActorBehavior
    extend ActiveSupport::Concern

    def create
      transform_dates
      super
    end

    def update
      transform_dates
      super
    end

    # If date is a String, cast it to a DateTime
    def transform_dates
      return if attributes['date_issued'].blank?
      return if attributes['date_issued'].is_a?(DateTime)
      attributes['date_issued'] = DateTime.parse(attributes['date_issued']).utc
    end
  end
end
