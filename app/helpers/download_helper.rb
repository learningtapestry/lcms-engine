# frozen_string_literal: true

module DownloadHelper
  def file_icon(type)
    %w(excel doc pdf powerpoint zip).include?(type) ? type : 'unknown'
  end
end
