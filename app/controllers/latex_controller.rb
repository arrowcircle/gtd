# coding: utf-8
Mime::Type.register "image/png", :png
class LatexController < ApplicationController
  respond_to :png
  def index
    latex = LaTeX::Renderer.new
    @image = latex.render('\frac{1}{2}')[0]
    respond_with(@image)
    
  end
end
