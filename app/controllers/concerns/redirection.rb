# frozen_string_literal:true

# redirect to different pages according to role
module Redirection
  extend ActiveSupport::Concern

  def redirect_by_role(user)
    if user.role == Constants::ROLE_SELLER
      redirect_to seller_dashboard_products_path
    else
      redirect_to products_path
    end
  end
end
