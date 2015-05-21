require 'pry'
require 'active_support/all'

module Dramavladimir
  class Repertoire
    attr_accessor :doc, :url, :spectacle

    def initialize(attributes = {})
      @site = "http://www.dramavladimir.ru"
      @url = "#{@site}/playbill"
      doc
    end

    def spectacles
      spectacles = []
      get_afisha_links.each do |link|
        Dramavladimir.parse("#{@site}/#{link}").search('.mceItemTable tr').each do |spectacle|
          @spectacle = spectacle
          next unless schedules
          s = { title: title, scene: scene, schedules: schedules }
          s = s.merge({ content: announce.content, video: announce.video, images: announce.images }) if announce
          spectacles << s
        end
      end
      spectacles
    end

    def title
      title = if spectacle.css('td a strong').last.nil? && spectacle.css('td strong').last.nil?
        spectacle.css('td b').last
      elsif spectacle.css('td a strong').last.nil? && spectacle.css('td b').last.nil?
        spectacle.css('td strong').last
      else
        spectacle.css('td a strong').last
      end
      title.inner_text.mb_chars.capitalize.to_s
    end

    def schedules
      return false if spectacle.at_css('td').inner_text.empty?
      t = DateTime.parse spectacle.at_css('td').inner_text.gsub!(/ПН|ВТ|СР|ЧТ|ПТ|СБ|ВС|\n/im, '')
      t.to_formatted_s(:db)
    end

    def scene
      spectacle.css('td').last.inner_text.mb_chars.downcase.to_s
    end

    private

    def get_afisha_links
      doc.search('#main-mid table.blog a.contentpagetitle').map { |e| e.attribute('href').value }
    end

    def announce
      return if spectacle.css('td a').first.nil?
      Dramavladimir::Announce.new(spectacle.css('td a').attribute('href').value)
    end

    def doc
      @doc ||= Dramavladimir.parse(url)
    end
  end
end
