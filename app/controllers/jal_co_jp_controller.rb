# This controller manages password generation and evaluation for jal.co.jp
class JalCoJpController < ApplicationController
  # GET /jal.co.jp
  def index
    generator = Www::JalCoJp.new
    @password = generator.create
    evaluator = Passwords::StrengthEvaluator.new(@password)
    @guesses_log10 = evaluator.guesses_log10
    @score = evaluator.score

    render_password_response
  end
end
