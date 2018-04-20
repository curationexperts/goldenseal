class AdminSetForm
  include HydraEditor::Form
  self.terms = [
    :contributor,
    :creator,
    :description,
    :identifier,
    :language,
    :publisher,
    :subject,
    :thumbnail_id,
    :title
  ]

  self.model_class = ::AdminSet

  # @return [Hash] All generic files in the collection, file.to_s is the key, file.id is the value
  def select_files
    Hash[member_thumbnails]
  end

  private

    def member_thumbnails
      member_presenters.map { |x| puts "*** #{x.inspect}"; [x.to_s, x.thumbnail_id] }
    end

    def member_presenters
      CurationConcerns::PresenterFactory.build_presenters(
        model.member_ids,
        WorkShowPresenter,
        nil)
    end
end
