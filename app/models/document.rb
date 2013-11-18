class Document < ActiveRecord::Base
	belongs_to :user
	before_create :update_fields
	validates :user_id, presence: true
	#validates :visibility, presence: true
	#validates :file, presence:true
	#has_attached_file :file, :url=>"/public/documents/:basename.:extension", :path=>":rails_root/public/documents/:basename.:extension"
	has_attached_file :file, :url=>"/public/documents/", :path=>":rails_root/public/documents/"

	attr_accessor :file_file_name

	private

		def update_fields
			#self.file = file.original_filename
			#self.user_id = current_user.id
		end
end
