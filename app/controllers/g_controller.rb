# This controller handles requests related to password generation and evaluation.
class GController < ApplicationController
  # GET /g
  def index
    generator = Passwords::StandardGenerator.new
    @password = generator.create
    evaluator = Passwords::StrengthEvaluator.new(@password)
    @guesses_log10 = evaluator.guesses_log10
    @score = evaluator.score

    render_password_response
  end
end
