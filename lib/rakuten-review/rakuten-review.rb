require 'nokogiri'
require 'open-uri'
require_relative "review/version"
require_relative 'review/review'

module RakutenReview
  def self.find_reviews(url)
    reviews = []
    delay = 0.5
    page = 1

    # iterate through the pages of reviews

    begin
      html = open(url).read.encode("UTF-8")
      doc = Nokogiri::HTML.parse(html)
      link = doc.css('a[contains("すべてのレビューを見る")]').first
      review_page_url = link["href"]
      html = open(review_page_url).read.encode("UTF-8")
      doc = Nokogiri::HTML.parse(html)
      doc.css(".revRvwUserSec.hreview").each do |review_html|
        reviews <<  Review.new(review_html)
      end
      # go to next page
      break

    rescue Exception => e # error while parsing (likely a 503)
      delay += 0.5 # increase delay

    end until new_reviews == 0

    reviews
  end

end
