module CurationConcerns
  # This is intended to be used in a non-concurrent application
  # It sacrifices concurency & appending each item for speed
  class ImportFileActor < FileSetActor
    def attach_file_to_work(work, file_set, file_set_params)
      unless assign_visibility?(file_set_params)
        copy_visibility(work, file_set)
      end
      # work.ordered_members << file_set
    end
  end
end
