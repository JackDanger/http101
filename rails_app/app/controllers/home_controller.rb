class HomeController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def gerbils
    binding.pry
    render :text => 'Gerbils!'
  end

  def penguins
    binding.pry
    render :text => 'Penguins!'
  end
end
