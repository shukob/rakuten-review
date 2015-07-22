module RakutenReview
  class Review
    def initialize(html)
      @html = html
      @div = html
    end

    def inspect
      "<Review: id=#{id}>"
    end

    def url
      @url ||= @html.css('a[contains("このレビューのURL")]').first["href"]
    end

    def user_id
      regex = /[A-Z0-9]+/
      @user_id ||= @div.css('a[href^="/gp/pdp/profile"]').first["href"][regex]
    end

    def title
      @title ||= @html.css('.revRvwUserEntryTtl.summary').first.text
    end

    def date
      @date ||= Date.parse(@html.css('.revUserEntryDate.dtreviewed').first.text)
    end

    def text
      # remove leading and trailing line returns, tabs, and spaces
      @text ||= @html.css('.revRvwUserEntryCmt.description').first.text
    end

    def rating
      @rating ||= Float(@html.css('.revUserRvwerNum.value').first.text)
    end

    def helpful_count
      @helpful_count ||= Int(@html.css('.revEntryAnsNum').first.text)
    end

    def to_hash
      attrs = [:url, :user_id, :title, :date, :text, :rating, :helpful_count]
      attrs.inject({}) do |r, attr|
        r[attr] = self.send(attr)
        r
      end
    end

  end
end
