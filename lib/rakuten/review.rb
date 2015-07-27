require 'nokogiri'
require 'open-uri'
require_relative "review/version"
require_relative 'review/review'

module Rakuten
  module Review
    def self.find_reviews(url)
      reviews = []

      # iterate through the pages of reviews

      html = open(url).read.encode("UTF-8")
      doc = Nokogiri::HTML.parse(html)
      link = doc.css('a[contains("すべてのレビューを見る")]').first
      review_page_url = link["href"]
      html = open(review_page_url).read.encode("UTF-8")
      doc = Nokogiri::HTML.parse(html)
      doc.css(".revRvwUserSec.hreview").each do |review_html|
        reviews << ::Rakuten::Review::Review.new(review_html)
        reviews
      end

    end
  end
end
