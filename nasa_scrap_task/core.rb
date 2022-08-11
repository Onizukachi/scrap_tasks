require 'nokogiri'
require 'open-uri'
require 'byebug'
require 'net/http'
require 'date'
require 'net/http'
require 'json'

def parse(url = 'https://www.nasa.gov/press-release/nasa-industry-to-collaborate-on-space-communications-by-2025')
  main_page = Nokogiri::HTML(URI.open(url))

  additional_url =  main_page.css("script")[4].text[/\/.+\d/]
  additional_url = URI("https://www.nasa.gov/api/2#{additional_url}")

  response = Net::HTTP.get(additional_url)
  hash = JSON.parse(response)

  solution = {}

  solution[:title] = hash['_source']['title']

  solution[:date] = (Date.parse(hash['_source']['promo-date-time'])).to_s

  solution[:release_no] = hash['_source']['release-id']

  body =  hash['_source']['body']

  solution[:body] = body.strip.gsub("\u00A0", " ").squeeze(" ")
                                                  .gsub(%r{</?[^>]+?>}, '')
                                                  .gsub(/\n{2,}/, "\n")
                                                  .delete_suffix("\n-end-")
                                                  .sub(/\n1-tdrs.+NASA\n/m, '')

  solution
end