class StaticPagesController < ApplicationController
  def help
  end

  def home
    @msg = 'Miraculous Ladybug!'
  end
  
  def about
  end
  
  def contact
  end
end
