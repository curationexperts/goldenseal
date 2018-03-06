class QaRightsTerm < ActiveRecord::Base
end

module Qa::Authorities
  class RightsAuthority < Qa::Authorities::Base
    def search q
      QaRightsTerm.where('term LIKE ?', "#{q}%").map do |term| 
        ActiveSupport::HashWithIndifferentAccess.new({"id" => term.term_id, "term" => term.term, "label" => term.term})
      end
    end

    def find id
      term = QaRightsTerm.where(term_id: id).first
      term.nil? ? nil : ActiveSupport::HashWithIndifferentAccess.new({"id" => term.term_id, "term" => term.term, "label" => term.term})
    end

    def all
      QaRightsTerm.all.map do |term| 
        ActiveSupport::HashWithIndifferentAccess.new({"id" => term.term_id, "term" => term.term, "label" => term.term})
      end
    end
  end
end
