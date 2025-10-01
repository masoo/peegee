# This controller manages password generation and evaluation for kuronekoyamato.co.jp.
class KuronekoyamatoCoJpController < ApplicationController
  # GET /kuronekoyamato.co.jp
  def index
    generator = Www::KuronekoyamatoCoJp.new
    @password = generator.create
    evaluator = Passwords::StrengthEvaluator.new(@password)
    @entropy = evaluator.entropy
    @score = evaluator.score

    render_password_response
  end
end
