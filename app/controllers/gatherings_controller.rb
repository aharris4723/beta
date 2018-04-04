class GatheringsController < ApplicationController
 def index
    @gathering = Gathering.new
    @gatherings = Gathering.all
    @user = User.find_by_id(params[:id])
    
  
  end

  def show
   @user = User.find_by_id(params[:id])
   
   @comments = Comment.all
   @comment = Comment.new  
   @gathering = Gathering.find(params[:id])
   
  end

 
  def new
    @gathering = Gathering.new
    
  end
  
  
        def create
    @gathering = Gathering.new(gathering_params)
    @gathering.user_id = current_user.id

    if @gathering.save
      redirect_to gatherings_path
    else 
      render new_gathering_path
    end
  end


 
  def update
    respond_to do |format|
      if @gathering.update(gathering_params)
        flash[:notice] = 'Your event was created successfully.'
			redirect_to '/gatherings'
		else
      flash[:alert] = 'Sorry, please try again.'  
			render new_gathering_path
      end
    end
  


  def destroy
   @comment = Comment.find(params[:id])
   @comment.destroy
        redirect_to "/comments/#{comment.post_id}"
    @event.destroy
     flash[:alert] = 'you have deleted this event.'
    
    end
  end

  private
  

    def gathering_params
      params.require(:gathering).permit(:name, :title, :content, :user_id)
    end
end
