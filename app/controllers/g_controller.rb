# This controller handles requests related to password generation and evaluation.
class GController < ApplicationController
  # GET /g
  def index
    generator = Passwords::StandardGenerator.new
    @password = generator.create
    evaluator = Passwords::StrengthEvaluator.new(@password)
    @entropy = evaluator.entropy
    @score = evaluator.score

    render_password_response
  end
end
