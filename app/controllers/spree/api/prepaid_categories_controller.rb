module Spree
	module Api
		class PrepaidCategoriesController < BaseApiController
			def index
				@prepaid_categories = Prepaid::PrepaidCategory.all.ransack(params[:q]).result
				render "spree/api/prepaid_categories/index"
			end
		end
	end
end