class Document < ActiveRecord::Base
	belongs_to :user
	before_save :update_fields
	default_scope -> { order('created_at DESC') }
	acts_as_taggable
	validates :user_id, presence: true
	validates :name, presence: true
	validates :uploaded_file, presence:true, on: :create
	has_attached_file :uploaded_file, :url=>"/public/documents/:basename.:extension", :path=>":rails_root/public/documents/:basename.:extension"
	#has_attached_file :uploaded_file, :url=>"/public/documents/", :path=>":rails_root/public/documents/"

	attr_accessor :uploaded_file_file_name

	def self.search(search)
	  if search
	    find(:all, :conditions => ['lower(name) LIKE ?', "%#{search.downcase}%"])
	  else
	    #find(:all)
	  end
	end

	private

		def update_fields
			unless uploaded_file.original_filename.nil?
				# Give random name to file
				extension = File.extname(uploaded_file_file_name).downcase
    		self.uploaded_file.instance_write(:file_name, "#{SecureRandom.hex(16)}#{extension}")

    		# Saves filename in database field 'file'
				self.file = uploaded_file.original_filename
			end
		end
end
