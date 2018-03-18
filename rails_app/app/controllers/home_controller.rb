class HomeController < ApplicationController

  skip_before_action :verify_authenticity_token

  def gerbils
    binding.pry
    render plain: 'Gerbils!', status: :ok
  end

  def penguins
    binding.pry
    render plain: 'Penguins!', status: :ok
  end
end
