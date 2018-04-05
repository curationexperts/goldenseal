# This module needs to be included after CurationConcerns::CurationConcernController
module Downloads
  extend ActiveSupport::Concern

  def toggle_prevent_download(object, value, file_type)
    authorize! :edit, object
    case file_type
    when 'video'
      works = object.members.select{ |work| work.class == Video }
    when 'text'
      works = object.members.select{ |work| work.class == Text }
    when 'audio' 
      works = object.members.select{ |work| work.class == Audio }
    when 'image'
      works = object.members.select{ |work| work.class == Image }
    when 'all'
      works = object.members
    end

    works.each do |work|
      # map through the file set of each work and find the file set that is the representative media, update its prevent_download attribute
      rep_media = work.file_sets.select { |fs| fs.id == work.representative_id }.first
      if rep_media.present?
        rep_media.update_attributes( prevent_download: value )
      end
    end
  end
end

