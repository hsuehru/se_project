class CommentController < ApplicationController
  skip_before_filter :verify_authenticity_token
  after_action :access_control_headers
  before_action :new_hash

  def new
    params = get_new_comment_params
    requirement = Requirement.find_by(:id => params[:rid])
    user = User.find_by(:id => params[:uid])
    if requirement.nil?
      @message[:result] = "failed"
      @message[:message] = "Requirement not found."
    else
      params.delete(:rid)
      params.delete(:uid)
      params[:user] = user
      comment = Comment.new(params)
      comment.requirement = requirement
      if comment.save
        @message[:result] = "success"
      else
        @message[:result] = "failed"
        @message[:message] = "comment save failed."
      end
    end
    render :json => @message.to_json
  end

  def update
    params = get_update_comment_params
    comment = Comment.find_by(:id => params[:id])
    user = User.find_by(:id => params[:uid])
    if comment.nil?
      @message[:result] = "failed"
      @message[:message] = "Comment not found."
    else
      params.delete(:id)
      params.delete(:uid)
      params[:user] = user
      if comment.update(params)
        @message[:result] = "success"
      else
        @message[:result] = "failed"
        @message[:message] = "comment update failed."
      end
    end
    render :json => @message.to_json

  end

  def test
    params = get_test
    # test = ActiveSupport::JSON.decode(params[:rid_list])
    # puts "puts ======   ",params
    render :json => ActiveSupport::JSON.decode(params[:rid_list])[0]["id"]
  end

  def delete
    comment = Comment.find_by(:id => params[:cid])
    if comment.nil?
      @message[:result] = "failed"
      @message[:message] = "comment not found."
    else
      if comment.delete
        @message[:result] = "success"
      else
        @message[:result] = "failed"
        @message[:message] = "comment delete failed."
      end
    end
    render :json => @message.as_json
  end

  def getCommentListByRequirementId
    requirement = Requirement.find_by(:id => params[:rid])

    if requirement.nil?
      @message[:result] = "failed"
      @message[:message] = "requirement not found."
    else
      comment_list = requirement.comments
      @message[:result] = "success"
      @message[:comment_list] = comment_list
    end
    render :json => @message.to_json(include: [:user,:requirement],except: [:updated_at])
  end
private
  def get_new_comment_params
    params.permit(:rid, :uid,:comment, :decision)
  end
  def get_update_comment_params
    params.permit(:id, :uid,:comment, :decision)
  end

  def get_test
    params.permit(:rid_list)
  end

########################################################################################################
  def new_hash
    @message = Hash.new
  end

  def access_control_headers
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
  end
end
