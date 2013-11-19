class DocumentsController < ApplicationController
	before_action :signed_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]

  def new
  	@document = current_user.documents.build
  end

  def create
  	@document = current_user.documents.build(document_params)
  	if (@document.save)
  		flash[:success] = "Document uploaded successfully!"
  		redirect_to documents_user_path(current_user)
  	else
  		render 'new'
  	end
  end

  def destroy
    path = "public/documents/#{@document.file}"
    File.delete(path) if File.exist?(path)
    @document.destroy
    flash[:success] = "Document deleted successfully!"
    redirect_to documents_user_path(current_user)
  end

  def edit
  end

  def update
    if (@document.update_attributes(document_params))
      flash[:success] = "Document updated successfully!"
      redirect_to documents_user_path(current_user)
    else
      render 'edit'
    end
  end

  def download
    document = Document.find(params[:id])
    path = "#{Rails.root}/public/documents/#{document.file}"
    # File.chmod(0604, path)
    send_file path#, :type=>"application/zip"
  end

  def search
    unless params[:name].nil? || params[:tags].nil?
      @name = params[:name]
      @tags = params[:tags]

      if !@tags.empty?
        docs = Document.search(@name)
        @documents = Array.new
        docs.each do |d|
          if @tags.in?(d.tag_list)
            @documents.push(d)
          end
        end
      else
        @documents = Document.search(@name)
      end
    end
  end

  private

  	def document_params
  		params.require(:document).permit(:uploaded_file, :name, :visibility, :user_id, :tag_list)
  	end

    def correct_user
      @document = Document.find(params[:id])
      unless current_user.admin?
        redirect_to root_url unless @document.user_id==current_user.id
      end
    end
end
