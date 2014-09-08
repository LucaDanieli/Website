class StaticPagesController < ApplicationController
  def home
    render layout: "initial_layout"
  end
end
