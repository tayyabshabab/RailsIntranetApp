require 'spec_helper'
require "paperclip/matchers"

describe "Document Pages" do
  
  subject { page }

  describe "user documents" do
  	let(:user) { FactoryGirl.create(:user) }

  	before do
  		sign_in user
  		visit documents_user_path(user)
  	end

  	it { should have_content("View Documents") }
  	it { should have_title("User Documents") }
  	it { should have_link("Create New Document", href: new_document_path) }

  	describe "pagination" do
      before (:each) { 30.times { FactoryGirl.create(:document, user: user) } }
      after(:all) { Document.delete_all }

      #it { should have_selector('div.pagination') }

      it "should list each document" do
        Document.paginate(page: 1) .each do |d|
          #expect(page).to have_selector('td', text: d.name)
        end
      end
    end

  	describe "adding a new document" do

  		before { visit new_document_path }
  		
  		describe "with invalid information" do

  			it "should not create document" do
  				expect { click_button "Upload document" }.not_to change(Document, :count)
  			end

  			describe "error messages" do
  				before { click_button "Upload document" }
  				it { should have_content('error') }
  			end
  		end

  		describe "with valid information" do
  			before do
	  			fill_in "Name",				with: "test"
	  			file_path = Rails.root + "spec/fixtures/decimal.jpg"
	  			attach_file('File to Upload', file_path)
	  		end

	  		it "should add a new document" do
	  			expect { click_button "Upload document" }.to change(Document, :count).by(1)
	  		end
  		end
  	end

  end
end
