# This controller manages Japanese secret questions, generating passwords and evaluating their strength.
class JapaneseSecretQuestionsController < ApplicationController
  # GET /japanese_secret_questions
  def index
    generator = Passwords::HiraganaGenerator.new
    @password = generator.create
    evaluator = Passwords::StrengthEvaluator.new(@password)
    @entropy = evaluator.entropy
    @score = evaluator.score

    render_password_response
  end
end
