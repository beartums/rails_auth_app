class StaticPagesController < ApplicationController
  def help
    @title = 'Help'
  end

  def home
    @msg = 'Miraculous Ladybug!'
    @title = 'Home'
  end
  
  def about
    @title = 'About'
  end
end
