class FaqController < ApplicationController
  before_action :set_current_user


  def show
    # @item is already set by set_item
    @faq_questions = [
      { question: "How do I sign up?", answer: "Click the Sign Up button on the homepage to create an account." },
      { question: "How do I change my password?", answer: "Go to your account settings and select Change Password." },
    # More FAQs
    ]
  end

end
