class MediumUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  storage :file
  after :store, :delete_tmp_dir
  after :remove, :delete_empty_dirs

  # Override the directory where uploaded files will be stored.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  # Remove tmp upload folders
  def delete_tmp_dir(new_file)
    # make sure we don't delete other things accidentally by checking the name pattern
    if @cache_id_was.present? && @cache_id_was =~ /\A[\d]{8}\-[\d]{4}\-[\d]+\-[\d]{4}\z/
      FileUtils.rm_rf(File.join(root, cache_dir, @cache_id_was))
    end
  end

  # Cleanup, remove empty folders
  def delete_empty_dirs
    path = ::File.expand_path(store_dir, root)
    Dir.delete(path)
  rescue
    true
  end

  def extension_white_list
    case model.class.name
      when 'Document'
        %w(pdf)
      when 'Image'
        %w{jpeg jpg gif tff bmp png}
      when 'Text'
        %w{txt}
      when 'Recording'
        # Recording allows the audio file as well as the transcript
        %w{wav mp3 pdf}
    end
  end

end
