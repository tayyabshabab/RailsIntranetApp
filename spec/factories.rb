FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
    	admin true
    end
  end

  factory :document do
  	name "Test Document"
  	uploaded_file Rack::Test::UploadedFile.new(Rails.root + "spec/fixtures/decimal.jpg" ,'image/jpg')
  	user
  end

  factory :wrong_user do
    name ""
    email "wrong"
    password "pass"
    password_confirmation "123"
  end
end