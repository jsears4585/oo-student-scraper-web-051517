require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper
  def self.scrape_index_page(index_url)
    raw_doc = File.read(index_url)
    index = Nokogiri::HTML(raw_doc)
    profile_ary = []
    index.css('.student-card').each do |student|
      hash = {}
      hash[:name] = student.css('.student-name').text
      hash[:location] = student.css('.student-location').text
      hash[:profile_url] = student.css('a').attribute('href').value
      profile_ary << hash
    end
    profile_ary
  end

  def self.scrape_profile_page(profile_url)
    raw_doc = File.read(profile_url)
    profile = Nokogiri::HTML(raw_doc)
    hash = {}
    sic = profile.css('.social-icon-container a')
    sic.each do |html|
      unless html.nil?
        href = html.attribute("href").value
        if href.match(/twitter/)
          hash[:twitter] = href
        elsif href.match(/linkedin/)
          hash[:linkedin] = href
        elsif href.match(/github/)
          hash[:github] = href
        end
      end
    end
    hash[:profile_quote] = profile.css('.profile-quote').text unless profile.css('.profile-quote').nil?
    hash[:bio] = profile.css('.description-holder p').text unless profile.css('.description-holder p').nil?
    hash
  end
end
