class SmartExJpController < ApplicationController
  def index
    @password = Www::SmartExJp.create
    @entropy = Passwords::Generators.entropy(@password)
    @score = Passwords::Generators.score(@password)

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
