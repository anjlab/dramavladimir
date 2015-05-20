module Dramavladimir
  class Announce
    attr_accessor :doc, :url

    def initialize(url, attributes = {})
      @url = url
    end

    def content
      doc.css('#main-mid p').map { |c| c.inner_text }.join('<br />').gsub(/\n|\t/, '').sub(/title=.JoomlaWorks AllVideos Player.>/, '')
    end

    def video
      return if doc.css('.avPlayerWrapper.avVideo').empty?
      doc.at_css('.avPlayerWrapper.avVideo iframe').attribute('src').value
    end

    def images
      return if doc.nil? || doc.css('.rokbox-album-inner').empty?
      doc.css('.rokbox-album-inner a').map { |image| "#{@site}#{image.attribute('href').value}" }
    end

    private

    def doc
      @doc ||= Dramavladimir.parse(url)
    end
  end
end
