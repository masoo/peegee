# This controller manages password generation and evaluation for rakuten-bank.co.jp
class RakutenBankCoJpController < ApplicationController
  # GET /rakuten-bank.co.jp
  def index
    generator = Www::RakutenBankCoJp.new
    @password = generator.create
    evaluator = Passwords::StrengthEvaluator.new(@password)
    @entropy = evaluator.entropy
    @score = evaluator.score

    render_password_response
  end
end
