require 'spec_helper'

describe "StaticPages" do

	subject { page }

	describe "Homepage" do
		before { visit root_path }

		it { should have_content("IntranetApp") }
		it { should have_title("IntranetApp") }
	end

	describe "Help page" do
		before { visit root_path }

		it { should have_content("Help") }
		it { should have_title("Help") }
	end
end
