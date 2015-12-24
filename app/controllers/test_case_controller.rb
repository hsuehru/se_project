class TestCaseController < ApplicationController
  skip_before_filter :verify_authenticity_token
  after_action :access_control_headers

  before_action :new_hash
  def new
    params = get_test_case_params

    require_list = params[:rid_list]
    # puts "=============================================="
    # p require_list
    # puts "=============================================="
    # ActiveSupport::JSON.decode(
    user = User.find_by(:id => params[:asigned_as])
    owner = User.find_by(:id => params[:owner])
    # ActiveSupport::JSON.decode(str)
    if user.nil?
      @message[:result] = "failed"
      @message[:message] = "User not found."
    else
      test_case = TestCase.create!(:name => params[:name],
                                   :description => params[:description],
                                   :owner => owner,
                                   :asigned_as => user,
                                   :input_data => params[:input_data],
                                   :expected_result => params[:expected_result],
                                   :finished => false
      )

      require_list.to_s.split(",").each do |requirement_id|
        requirement = Requirement.find_by(:id => requirement_id)
        RequirementTestCaseship.create!(:requirement => requirement, :test_case => test_case)
      end
      @message[:result] = "success"
    end



    render :json => @message.to_json
  end

  def update
    params = get_update_test_case_params
    test_case =  TestCase.find(params[:id])
    user = User.find(params[:asigned_as])
    owner = User.find(params[:owner])

    params[:asigned_as] = user
    params[:owner] = owner

    params.delete(:id)
    if test_case.update(params)
      @message[:result] = "success"
    else
      @message[:result] = "false"
    end
    render :json => @message.to_json
  end

  def delete
    # require_test_ship_find_flag = false
    # delete_list = Array.new
    test_case = TestCase.find_by(:id => params[:tid])
    if test_case.nil?
      @message[:result] = "failed"
      @message[:message] = "test case not found."
    else
      requirement_list = test_case.requirements
      requirement_list.each do |r|
        require_test_ship = RequirementTestCaseship.find_by(:requirement => r,
                                                          :test_case => test_case)
        require_test_ship.delete
      end
      test_case.delete
      @message[:result] = "success"

    end

    render :json => @message.to_json

  end

  def deleteRequirementTestRelationship
    params = delete_relationship_params
    requirement = Requirement.find_by(:id => params[:rid])
    test_case = TestCase.find_by(:id => params[:tid])

    requirement_test_case_ship = RequirementTestCaseship.find_by(:requirement => requirement, :test_case => test_case)
    if requirement_test_case_ship.nil?
      @message[:result] = "failed"
      @message[:message] = "requirement has not relationship wiht it."
    else
      if requirement_test_case_ship.delete
        @message[:result] = "success"
      else
        @message[:result] = "failed"
        @message[:message] = "delete failed."
      end
    end

    render :json => @message.to_json

  end

  def getTestCaseListByProjectId
    project = Project.find_by(:id => params[:pid])
    if project.nil?
      @message[:result] = "failed"
      @message[:message] = "Project not found."
    else
      RequirementTestCaseship.where(:requirement => project.requirements)
      test_case_ids = RequirementTestCaseship.select(:test_case_id).where(:requirement => project.requirements)
      test_cases = TestCase.select(:id,:name,:description,:owner,:asigned_as,:input_data,:expected_result,:finished,:created_at).where(:id => test_case_ids)
      @message[:result] = "success"
      @message[:test_case_list] = test_cases
    end
    render :json => @message.to_json

  end

  def getTestCaseListByRequirementId
    requirement = Requirement.find_by(:id => params[:rid])
    test_case = TestCase.select(:id,:name,:description,:owner,:asigned_as,:input_data,:expected_result,:finished,:created_at).where(:id => RequirementTestCaseship.select("test_case_id").where(:requirement => requirement))
    if test_case.nil?
      @message[:result] = "failed"
      @message[:message] = "Test case is not found."
    else
      @message[:result] = "success"
      @message[:test_case_list] = test_case
    end
    render :json => @message.to_json
  end

  def getTestCaseByTestCaseId
    test_case = TestCase.select(:id,:name,:description,:owner,:asigned_as,:input_data,:expected_result,:finished,:created_at).find_by(:id => params[:tid])
    if test_case.nil?
      @message[:result] = "failed"
      @message[:message] = "Test case is not found."
    else
      @message[:result] = "success"
      @message[:test_cae] = test_case
    end
    render :json => @message.to_json
  end
  ########################################################################################################
  def get_update_project_params
    params.permit(:rid_list, :name, :description, :asigned_as, :input_data, :expected_result)
  end
  def new_hash
    @message = Hash.new
  end
  private
  def get_test_case_params
    params.permit(:rid_list, :name, :description, :owner, :asigned_as, :input_data, :expected_result)
  end

  def delete_relationship_params
    params.permit(:rid,:tid)
  end

  def get_update_test_case_params
    params.permit(:id, :name, :description, :owner, :asigned_as, :input_data, :expected_result)
  end

  def access_control_headers
    headers['Access-Control-Allow-Origin'] = "*"
    headers['Access-Control-Request-Method'] = %w{GET POST OPTIONS}.join(",")
  end
end
