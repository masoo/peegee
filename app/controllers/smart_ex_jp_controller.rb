# This controller manages password generation and evaluation for smart-ex.jp
class SmartExJpController < ApplicationController
  # GET /smart-ex.jp
  def index
    generator = Www::SmartExJp.new
    @password = generator.create
    evaluator = Passwords::StrengthEvaluator.new(@password)
    @entropy = evaluator.entropy
    @score = evaluator.score

    render_password_response
  end
end
