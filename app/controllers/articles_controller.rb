require 'open-uri'

class ArticlesController < ApplicationController
  def index
    @articles = Article.last(5)
    @article = Article.new
  end

  def create
    wikipedia_link = article_params[:wikipedia_link]

    if valid_wikipedia_link?(wikipedia_link)
      page = Nokogiri::HTML(URI.open(wikipedia_link))
      title = page.css('h1#firstHeading').text
      languages = page.css('.interlanguage-link a').map { |a| a.text }
      @article = Article.new({
        title: title,
        languages: languages
      })

      respond_to do |format|
        if @article.save
          format.html { redirect_to articles_url, notice: "Article was successfully found" }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    else
      redirect_to articles_url, alert: "Wikipedia link is invalid. Please try again!"
    end
  end

  private

  def article_params
    params.require(:article).permit(:wikipedia_link)
  end

  def valid_wikipedia_link?(link)
    # Use a regular expression to match Wikipedia article URLs
    wikipedia_pattern = %r{https?://(www\.)?en\.wikipedia\.org/wiki/.+}
  
    !!(link =~ wikipedia_pattern)
  end
end
