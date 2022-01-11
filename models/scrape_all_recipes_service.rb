require 'nokogiri'
require 'open-uri'
require_relative 'recipe'

class ScrapeAllrecipesService
  def initialize(keyword)
    @keyword = keyword
  end

  def scrapping
    url = "https://www.allrecipes.com/search/results/?search=#{@keyword}"
    doc = Nokogiri::HTML(URI.open(url).read, nil, 'utf-8')

    doc.search('.card__recipe').first(12).map do |container|
      name = container.search('.card__title').text.strip
      description = container.search('.card__summary').text.strip
      rating = container.search('.review-star-text').text.strip.split[1]
      img_url = container.search('img').attribute('src').value
      Recipe.new(name: name, description: description, rating: rating, img_url: img_url)
    end
  end
end
