# frozen_string_literal: true

class SocialMediaPresenter
  attr_reader :target, :view

  def initialize(target:, view:)
    @target = target
    @view = view
  end

  def title
    title_ = target.try(:title).try(:html_safe)
    clean(title_) || clean(view.content_for(:og_title)) || view.page_title
  end

  def description
    desc = target.try(:teaser).try(:html_safe)
    clean(desc) || clean(view.content_for(:og_description)) || view.page_description
  end

  def default
    OpenStruct.new(
      # use facebook image as default
      image: thumbnails[:facebook] || view.page_og_image,
      title: title,
      description: description
    )
  end

  def facebook
    @facebook ||= extend_with_default(
      image: thumbnails[:facebook] || view.page_og_image
    )
  end

  def twitter
    @twitter ||= extend_with_default(
      # use same image as facebook for twitter
      image: thumbnails[:facebook] || view.page_og_image
    )
  end

  def pinterest
    @pinterest ||= extend_with_default(
      image: thumbnails[:pinterest] || view.page_og_image
    )
  end

  def thumbnails
    # @thumbnails ||=  begin
    #   if target
    #     target.social_thumbnails.reduce({}) do |dict, thumb|
    #       dict[thumb.media] = thumb.image.url + "?ts=#{Time.now.to_i}#{Random.rand(1_000_000)}"
    #       dict
    #     end.with_indifferent_access
    #   else
    #     {}
    #   end
    # end

    # According to issue 140 (https://github.com/learningtapestry/unbounded/issues/140)
    # we are commenting out social_thumbnails for now, until we can fix the titles and reparse the images.
    {}
  end

  def clean(str)
    view.strip_tags_and_squish(str)
  end

  def quick_reference_guide?
    (target.is_a?(Resource) || target.is_a?(ResourcePresenter)) && target.quick_reference_guide?
  end

  private

  def extend_with_default(data)
    OpenStruct.new default.to_h.merge(data.compact)
  end
end
