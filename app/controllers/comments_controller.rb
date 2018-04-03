class CommentsController < ApplicationController
def index
        @comments = Comment.all
    end

    def new
        @user = User.find(current_user.id)
        @gathering = Gathering.find(params[:gathering_id])
        @comment = Comment.new
    end

    def create

        user = User.find(current_user.id)
        comment = Comment.new(comment_params)
        comment.user_id = current_user.id
        if comment.save!
            flash[:message] = 'Your comment was posted'
            redirect_to "/gatherings/#{comment.gathering_id}"
        else
            flash[:message] = 'try again'
            render 'comments/'
        end
    end

    def show
        @comment = Comment.find_by_id(params[:id])
    end

    def edit
        @comment = Comment.find_by_id(params[:id])
    end

    def update
        @comment = Comment.find(params[:id])
        @gathering = Gathering.find_by_id(params[:id])
        if @comment.update(comment_params)
            flash[:message] = 'Your comment was edited'
            redirect_to "/gathering"
        else
            flash[:message] = 'try again'
            render "/comments/#{@comment.id}/edit"
        end
    end

    def destroy
        @gathering = Gathering.find_by_id(params[:id])
        @comment = Comment.find(params[:id])
        @comment.destroy
        redirect_to gatherings_path
    end

private

def comment_params
    params.require(:comment).permit(:content, :user_id, :gathering_id)
end


end
