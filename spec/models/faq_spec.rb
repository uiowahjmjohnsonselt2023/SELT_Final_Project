require 'spec_helper'
require 'rails_helper'

describe Faq, type: :model do

  model_faqs = [
    { question: "How do I sign up?", answer: "Click the Login button and sign in with a Google account." },
    { question: "Can I sell items on Deal Docks?", answer: "Yes, registered users can list items for sale. Click 'Sell Item' after logging in to list your item." },
    { question: "Is there a fee for using Deal Docks?", answer: "Listing items is free, but a small transaction fee is charged when an item is sold." },
    { question: "How do I pay for an item?", answer: "You can pay for an item using saved credit cards" },
    { question: "Can I leave feedback for a seller?", answer: "Yes, you can leave feedback for a seller after a transaction is complete by filling out a review." },
    { question: "How can I update my shipping address?", answer: "Go to your profile page, select edit profile, and add and delete your addresses" },
    { question: "How can I update my payment methods?", answer: "Go to your profile page, select edit profile, and add and delete your payment methods"},
    { question: "How can I update my profile information?", answer: "Go to your profile page, select edit profile, and update your information" },
    { question: "How can I bookmark an item?", answer: "Click the bookmark icon on the item page" },
    { question: "How can I view my bookmarks?", answer: "Go to your profile page, select 'Bookmarks'" },
    { question: "How can I view my listings?", answer: "Go to your profile page, select 'My Items for Sale'" },
    { question: "How can I view my purchases?", answer: "Go to your profile page, select 'My Purchases'" }
  ]

  describe 'questions' do
    #before do
    #  allow(Faq).to receive(:questions).and_return(model_questions_mock)
    #end

    it 'returns correct value' do
      expect(Faq.questions).to eq(model_faqs)
    end

  end






end
