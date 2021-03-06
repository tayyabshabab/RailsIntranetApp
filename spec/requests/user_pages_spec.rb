require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "index" do

    let(:user) { FactoryGirl.create(:admin ) }

    before do
      sign_in user
      visit users_path
    end

    it { should have_title("All users") }
    it { should have_content("All users") }
    it { should have_link('Edit', href: edit_user_path(User.first)) }

    describe "pagination" do
      before (:all) { 30.times { FactoryGirl.create(:admin) } }
      after(:all) { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1) .each do |user|
          expect(page).to have_selector('td', text: user.name)
        end
      end
    end

    describe "delete and edit links" do

      it { should_not have_link('delete') }
      #it { should have_link('edit') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('Delete', href: user_path(User.first)) }
        it { should have_link('Edit', href: edit_user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('Delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end

      describe "as non-admin user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }

        #before { sign_in non_admin, no_capybara: true }
        before do
          click_link('Sign out')
          sign_in non_admin, no_capybara: true
          #abort(URI.parse(current_url).to_s)
        end

        describe "when visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_content("Welcome") }
        end

        # describe "when submitting an EDIT request to the Users#edit action" do
        #   before do
        #     patch user_path(user)
        #   end
        #   specify { expect(response).to redirect_to(root_url) }
        # end

        # describe "when submitting an EDIT request to the Users#edit action" do
        #   before { patch user_path(user) }
        #   specify{ expect(response).to redirect_to(root_url) }
        # end

        # describe "submitting a DELETE request to the Users#destroy action" do
        #   before { delete user_path(user) }
        #   specify { expect(response).to redirect_to(root_url) }
        # end
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    #before { visit edit_user_path(user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in 'Name',               with: new_name
        fill_in 'Email',              with: new_email
        fill_in 'Password',           with: user.password
        fill_in 'Confirm Password',   with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end

  describe "documents" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit documents_user_path(user)
    end

    it { should have_content('View Documents') }

    
  end
end
