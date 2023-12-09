
class Faq < ApplicationRecord

  @@faqs = [
    { question: "How do I sign up?", answer: "Click the Login button and sign in with a Google account." },
    { question: "Can I sell items on Deal Docks?", answer: "Yes, registered users can list items for sale. Click 'Sell Item' after logging in to list your item." },
    { question: "Is there a fee for using Deal Docks?", answer: "Listing items is free, but a small transaction fee is charged when an item is sold." },
    { question: "What should I do if I encounter a problem with a transaction?", answer: "Please contact our support team immediately with details of the transaction." },
    { question: "Can I return an item?", answer: "Return policies are determined by individual sellers. Please check the item's description for return policy details." },
    { question: "How can I update my shipping address?", answer: "Go to your profile page, select edit profile, and add and delete your addresses" }
  ]

  def self.questions
    @@faqs
  end


end
