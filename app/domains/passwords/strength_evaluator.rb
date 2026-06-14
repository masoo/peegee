require "zxcvbn"

module Passwords
  # password strength evaluator
  class StrengthEvaluator
    attr_reader :guesses_log10, :score

    # @param password [String] password to evaluate
    def initialize(password)
      zxcvbn_result = Zxcvbn.test(password)
      @guesses_log10 = zxcvbn_result.guesses_log10
      @score = zxcvbn_result.score
    end
  end
end
