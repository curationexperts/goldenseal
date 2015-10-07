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

    # Format the date
    def transform_dates
      attributes['date_issued'] = DateService.parse(attributes['date_issued'])
    end
  end
end
