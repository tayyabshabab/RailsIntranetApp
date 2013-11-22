require 'spec_helper'

describe UsersController do

	let(:user) { FactoryGirl.create(:user) }
	let(:admin) { FactoryGirl.create(:admin) }

	before(:each) do
		# login(admin)
	end

  describe "GET #index" do
  	it "redirect non admin users to root" do
  		login(user)
  		get :index
  		response.should redirect_to :root
  	end

    it "renders the index template for admin user" do
    	login(admin)
      get :index
      response.should render_template :index
    end
  end

  describe "GET #show" do
  	it "populates the user" do
  		get :show, id: user
  		assigns(:user).should eq(user)
  	end

  	it "renders the show template" do
  		get :show, id: FactoryGirl.create(:user)
  		response.should render_template :show
  	end
  end

  describe "#new" do
  	it "redirect non logged in user to signin" do
  		get :new
  		response.should redirect_to :signin
  	end

  	it "redirect non admin user to root" do
  		login(user)
  		get :new
  		response.should redirect_to :root
  	end

  	it "renders new template for admin" do
  		login(admin)
  		get :new
  		response.should render_template :new
  	end
  end

  describe "#create" do

  	it "redirect non logged in user to signin" do
  		post :create, user: FactoryGirl.create(:user)
  		response.should redirect_to :signin
  	end

  	it "redirect non admin user to root" do
  		login(user)
  		post :create, user: FactoryGirl.create(:user)
  		response.should redirect_to :root
  	end

  	it "adds a new user when admin" do
  		login(admin)
  		expect {
  			post :create, user: FactoryGirl.create(:user).attributes
  		}.to change(User, :count).by(1)
  	end
  end

  describe "#update" do

  	before :each do
  		@user = FactoryGirl.create(:user)
  	end

  	it "redirect non logged in user to signin" do
  		put :update, id: @user, user: FactoryGirl.create(:user)
  		response.should redirect_to :signin
  	end

  	it "redirect non admin user to root" do
  		login(user)
  		put :update, id: @user, user: FactoryGirl.create(:user)
  		response.should redirect_to :root
  	end

  	it "updates user when admin" do
  		login(admin)
  		put :update, id: @user, user: {name: "tayyab", email: "tayyab_new@yahoo.com", password: "tayyab", password_confirmation: "tayyab"}
  		@user.reload
  		@user.name.should eq("tayyab")
  		@user.email.should eq("tayyab_new@yahoo.com")
  	end
  end

  describe "#delete" do

  	before :each do
  		@user = FactoryGirl.create(:user)
  	end

  	it "redirect non logged in user to signin" do
  		delete :destroy, id: @user
  		response.should redirect_to :signin
  	end

  	it "redirect non admin user to root" do
  		login(user)
  		delete :destroy, id: @user
  		response.should redirect_to :root
  	end

  	describe "when admin" do
  		before { login(admin) }

	  	it "deletes the contact" do
	  		expect {
	  			delete :destroy, id: @user
	  		}.to change(User, :count).by(-1)
	  	end

	  	it "redirects to users" do
	  		delete :destroy, id: @user
	  		response.should redirect_to :users
	  	end
  	end

  end
end