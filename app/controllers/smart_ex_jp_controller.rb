class SmartExJpController < ApplicationController
  def index
    @password = Www::SmartExJp.create
    @entropy = Passwords::Generators.entropy(@password)
    @score = Passwords::Generators.score(@password)

    respond_to do |format|
      format.any do
        render layout: false, formats: [ :text ], content_type: "text/plain"
      end
      format.json do
        render layout: false, json: {
          password: @password, entropy: @entropy, score: @score
        }
      end
    end
  end
end
