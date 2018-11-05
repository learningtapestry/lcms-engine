# frozen_string_literal: true

module DocumentsHelper
  def toc_time(time)
    time.zero? ? raw('&mdash;') : "#{time} mins"
  end
end
