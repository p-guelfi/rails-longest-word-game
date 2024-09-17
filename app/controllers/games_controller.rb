require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @submitted_word = params[:word]
    @letters = params[:letters]

    # Initialize points_accumulated from session or set it to 0 if not present
    @points_accumulated = session[:points_accumulated] || 0

    if letters_included_in_the_grid?(@submitted_word, @letters)
      if valid_english_word?(@submitted_word)
        @result = "<strong>Congratulations!</strong> <strong>#{@submitted_word}</strong> is a valid English word!".html_safe
        @points = @submitted_word.size
      else
        @result = "Sorry but <strong>#{@submitted_word}</strong> does not seem to be a valid English word...".html_safe
        @points = 0
      end
    else
      @result = "Sorry but <strong>#{@submitted_word}</strong> can't be built out of #{@letters}.".html_safe
      @points = 0
    end

    # Update points_accumulated with the current points
    @points_accumulated += @points

    # Store the updated points_accumulated in the session
    session[:points_accumulated] = @points_accumulated
  end



  private

  def letters_included_in_the_grid?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def valid_english_word?(word)
    response = URI.parse("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
