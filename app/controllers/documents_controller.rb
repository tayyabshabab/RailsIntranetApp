class DocumentsController < ApplicationController
	before_action :signed_in_user

  def new
  	@document = current_user.documents.build
  end

  def create
  	@document = current_user.documents.build(document_params)
  	if (@document.save)
  		abort(@document.file.original_filename)
  		flash[:success] = "Document successfully uploaded!"
  		redirect_to documents_user_path(current_user)
  	else
  		render 'new'
  	end

  end

  def destroy
  end

  def edit
  end

  private

  	def document_params
  		params.require(:document).permit(:file, :name, :visibility)
  	end
end
