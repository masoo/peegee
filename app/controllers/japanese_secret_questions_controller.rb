class JapaneseSecretQuestionsController < ApplicationController
  def index
    @password = Passwords::Generators.hiragana
    @entropy = Passwords::Generators.entropy(@password)
    @score = Passwords::Generators.score(@password)

    respond_to do |format|
      format.text do
        render layout: false, formats: [ :text ]
      end
      format.json do
        render layout: false, json: {
          password: @password, entropy: @entropy, score: @score
        }
      end
    end
  end
end
