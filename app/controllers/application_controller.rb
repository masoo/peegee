# This controller is the base controller for the entire application.
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  # Renders password response in different formats based on request type.
  def render_password_response
    respond_to do |format|
      format.json do
        render layout: false, formats: [ :json ], content_type: "application/json"
      end
      format.any do
        render layout: false, formats: [ :text ], content_type: "text/plain"
      end
    end
  end
end
