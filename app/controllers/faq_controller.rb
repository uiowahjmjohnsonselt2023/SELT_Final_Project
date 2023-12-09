class FaqController < ApplicationController

  def show
    # @item is already set by set_item
    @faq_questions = Faq.questions
  end

end
