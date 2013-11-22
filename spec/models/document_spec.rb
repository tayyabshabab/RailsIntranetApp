require 'spec_helper'

describe Document do

	before { @document = Document.new(user_id: 1, name: "My Test File", uploaded_file: "file.pdf",
							visibility: true) }

	subject { @document }

	it { should respond_to(:user_id) }
	it { should respond_to(:name) }
	it { should respond_to(:uploaded_file) }
	it { should respond_to(:visibility) }

	it { should be_valid }

end
