require 'nokogiri'
require 'open-uri'
require 'byebug'
require 'net/http'
require 'date'

module Parser
  class << self
    attr_accessor :url

    def parse(url = 'https://agriculture.house.gov/news/documentsingle.aspx?DocumentID=2546')
      url = self.url ||= url 
      uri = URI.open(url)
      page = Nokogiri::HTML(uri)
      parsing_and_format(page)
    end

    private

    def parsing_and_format(page)
      result = {title: nil,
                date: nil,
                location: nil,
                article: nil}

      title = page.css('div.single-headline').css('h2.newsie-titler')[0].text
      article = page.css('div.bodycopy')[0].text
      date_and_location = page.css('div.news-specs .topnewstext')[0].text

      result[:title] = clean_title(title)
      result[:article] = clean_article(article)
      result.merge(get_date_and_location(date_and_location))
    end

    def clean_article(raw_article)
      result = delete_all_space(raw_article)
      result.sub(/[A-Z]{2,}\s\W\s/, '')
    end
    
    def delete_all_space(str)
      str.strip.gsub("\u00A0", " ").squeeze(" ").delete_suffix(' ')
    end
    
    def clean_title(raw_title)
      delete_all_space(raw_title)
    end
    
    def get_date_and_location(raw_data)
      arr = delete_all_space(raw_data).split(",\r\n")
      { location: arr[0].strip, date: format_date(arr[1]) }
    end
    
    def format_date(date)
      Date.parse(date.strip).to_s
    end
  end
end