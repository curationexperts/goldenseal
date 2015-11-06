# This module needs to be included after CurationConcerns::CurationConcernController
module AttachFiles

  # Add the thumbnail, representative, and tei to the files list so they will be properly attached to the work.
  def add_attachments_to_files
    files = Array(params[hash_key_for_curation_concern]['representative']) +
            Array(params[hash_key_for_curation_concern]['tei']) +
            Array(params[hash_key_for_curation_concern]['thumbnail'])
    params[hash_key_for_curation_concern]['files'] ||= []
    params[hash_key_for_curation_concern]['files'] += files
  end

  # Override method from CurationConcerns::CurationConcernController
  def after_create_response
    assign_representative
    assign_tei
#    assign_thumbnail

    unless curation_concern.save
      flash['alert'] = 'There were problems assigning the representative, thumbnail, or transcript.  You may want to edit this work and select the correct files.'
    end

    super
  end

  def assign_representative
    return unless params[hash_key_for_curation_concern]['representative']
    curation_concern.representative = find_matching_file_set('representative')
  end

  def assign_tei
    return unless params[hash_key_for_curation_concern]['tei']
    curation_concern.tei = find_matching_file_set('tei')
  end

#  def assign_thumbnail
#    return unless params[hash_key_for_curation_concern]['thumbnail']
#    curation_concern.thumbnail = find_matching_file_set('thumbnail')
#  end

  def find_matching_file_set(hash_key_for_file)
    filename = Array(params[hash_key_for_curation_concern][hash_key_for_file]).first.original_filename
    curation_concern.file_sets.select {|fs| fs.label == filename }.first
  end

end
