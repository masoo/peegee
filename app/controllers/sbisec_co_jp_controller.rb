# This controller manages password generation and evaluation for sbisec.co.jp
class SbisecCoJpController < ApplicationController
  # GET /sbisec.co.jp
  def index
    generator = Www::SbisecCoJp.new
    @password = generator.create
    evaluator = Passwords::StrengthEvaluator.new(@password)
    @entropy = evaluator.entropy
    @score = evaluator.score

    render_password_response
  end
end
