module Spree
	module Api
		class PrepaidCategoriesController < BaseApiController
			before_action :authenticate_user, :except => [:index]
			
			def index
				@prepaid_categories = Prepaid::PrepaidCategory.all.ransack(params[:q]).result
				render "spree/api/prepaid_categories/index"
			end
		end
	end
end