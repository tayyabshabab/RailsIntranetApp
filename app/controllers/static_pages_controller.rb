class StaticPagesController < ApplicationController
  def home
  	@documents = Document.where(visibility: true)
  end

  def help
  end

  def about
  end

  def contact
  end
end
