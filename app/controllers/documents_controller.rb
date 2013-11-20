class DocumentsController < ApplicationController
	before_action :signed_in_user, except: [:search, :download]
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
    old_file = @document.file
    if (@document.update_attributes(document_params))
      if @document.file != old_file
        path = "public/documents/#{old_file}"
        File.delete(path) if File.exist?(path)
      end
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
    unless params[:name].nil?
      @name = params[:name]
      @documents = Document.search(@name)
    end
    unless params[:tags].nil?
      @tags = params[:tags]
      @documents = Document.tagged_with(@tags).where(visibility: true).paginate(page: params[:page])
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
