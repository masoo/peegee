# This controller manages password generation and evaluation for nenkin.go.jp.
class NenkinGoJpController < ApplicationController
  # GET /nenkin.go.jp
  def index
    generator = Www::NenkinGoJp.new
    @password = generator.create
    evaluator = Passwords::StrengthEvaluator.new(@password)
    @guesses_log10 = evaluator.guesses_log10
    @score = evaluator.score

    render_password_response
  end
end
