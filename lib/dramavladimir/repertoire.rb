require 'pry'
require 'active_support/all'

module Dramavladimir
  class Repertoire
    attr_accessor :doc, :url, :announce, :announce_content

    def initialize(attributes = {})
      @url = "http://www.dramavladimir.ru/playbill"
      doc
    end

    def spectacles
      spectacles = []
      get_afisha_links.each do |link|
        announces = Dramavladimir.parse("http://www.dramavladimir.ru/#{link}")
        announces.search('.mceItemTable tr').each do |announce|
          @announce = announce
          next unless prepare_date
          spectacles.push({
            title: prepare_title,
            scene: prepare_scene,
            content: prepare_content,
            video: prepare_video,
            images: prepare_images,
            schedules: prepare_date
          })
        end
      end
      spectacles
    end

    def get_afisha_links
      doc.search('#main-mid table.blog a.contentpagetitle').map { |e| e.attribute('href').value }
    end

    private

    def prepare_title
      title = if announce.css('td a strong').last.nil? && announce.css('td strong').last.nil?
        announce.css('td b').last
      elsif announce.css('td a strong').last.nil? && announce.css('td b').last.nil?
        announce.css('td strong').last
      else
        announce.css('td a strong').last
      end
      title.inner_text.mb_chars.capitalize.to_s
    end

    def prepare_date
      return false if announce.at_css('td').inner_text.empty?
      t = DateTime.parse announce.at_css('td').inner_text.gsub!(/ПН|ВТ|СР|ЧТ|ПТ|СБ|ВС|\n/im, '')
      t.to_formatted_s(:db)
    end

    def prepare_scene
      announce.css('td').last.inner_text.mb_chars.downcase.to_s
    end

    def prepare_content
      return '' unless announce_content
      announce_content.css('#main-mid p').map { |c| c.inner_text }.join(' ').gsub(/\n|\t/, '').sub(/title=.JoomlaWorks AllVideos Player.>/, '')
    end

    def prepare_video
      return if announce_content.nil? || announce_content.css('.avPlayerWrapper.avVideo').nil?
      announce_content.at_css('.avPlayerWrapper.avVideo iframe').attribute('src').value
    end

    def prepare_images
      return if announce_content.nil? || announce_content.css('.rokbox-album-inner').nil?
      announce_content.css('.rokbox-album-inner a').map { |image| image.attribute('href').value }
    end

    def announce_content
      return if announce.css('td a').first.nil?
      @announce_content ||= Dramavladimir.parse(announce.css('td a').attribute('href').value)
    end

    def doc
      @doc ||= Dramavladimir.parse(url)
    end
  end
end
