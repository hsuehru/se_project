Rails.application.routes.draw do
	post 'user/test' => 'user#test'
	post 'user/register' => 'user#register'
	post 'user/login' => 'user#login'

	post 'project/new' => 'project#new'
  post 'project/update' => 'project#update'
	post 'project/changeUserPriority' => 'project#changeUserPriority'
	post 'project/deleteUserFromProject' => 'project#deleteUserFromProject'



	post 'comment/new' => 'comment#new'
	post 'comment/update' => 'comment#update'
	post 'comment/test' => 'comment#test'

  get 'comment/delete/:cid' => 'comment#delete'
  get 'comment/getCommentListByRequirementId/:rid' => 'comment#getCommentListByRequirementId'
	get 'comment/delete/:tid' => 'comment#delete'



	get 'project/delete/:pid' => 'project#delete'

	get 'project/getOwnerProjectListByUserId/:uid' => 'project#getOwnerProjectListByUserId'
	get 'project/getManagerProjectListByUserId/:uid' => 'project#getManagerProjectListByUserId'
	get 'project/getMemberProjectListByUserId/:uid' => 'project#getMemberProjectListByUserId'
	get 'project/getCustomerProjectListByUserId/:uid' => 'project#getCustomerProjectListByUserId'
  get 'project/getProjectPriorityType' => 'project#getProjectPriorityType'

	get 'project/getProjectListByUser/:uid' => 'project#getProjectListByUser'
	get 'project/getUserListByProject/:pid' => 'project#getUserListByProject'
	post 'project/addUserToProject' => 'project#addUserToProject'



	get 'requirement/getPriorityType' => 'requirement#getPriorityType'
	get 'requirement/getStatusType' => 'requirement#getStatusType'
	get 'requirement/getRequirementType' => 'requirement#getRequirementType'
	get 'requirement/getRequirementByProject/:pid' => 'requirement#getRequirementByProject'
	get 'requirement/getRequirementById/:rid' => 'requirement#getRequirementById'
	get 'requirement/delete/:rid' => 'requirement#delete'
	get 'requirement/getRtoRRelationByProjectId/:pid' => 'requirement#getRtoRRelationByProjectId'
	get 'requirement/getRequirementListByTestCaseId/:pid' => 'requirement#getRequirementListByTestCaseId'
	get 'requirement/deleteRtoRRelationByProjectId/:pid' => 'requirement#deleteRtoRRelationByProjectId'









  get 'test_case/getTestCaseListByRequirementId/:rid' => 'test_case#getTestCaseListByRequirementId'
	get 'test_case/getTestCaseByTestCaseId/:tid' => 'test_case#getTestCaseByTestCaseId'
	get 'test_case/delete/:tid' => 'test_case#delete'
  get 'test_case/getTestCaseListByProjectId/:pid'=>'test_case#getTestCaseListByProjectId'




	post 'requirement/new' => 'requirement#new'
	post 'requirement/update' => 'requirement#update'
  post 'requirement/newRtoRRelation' => 'requirement#newRtoRRelation'


	post 'test_case/new' => 'test_case#new'
	post 'test_case/update' => 'test_case#update'
	post 'test_case/deleteRequirementTestRelationship' => 'test_case#deleteRequirementTestRelationship'









	get 'command/resetDB' => 'command/resetDB'

	get 'user/test' => 'user#test'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
