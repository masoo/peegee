require "zxcvbn"

module Passwords
  # password strength evaluator
  class StrengthEvaluator
    attr_reader :entropy, :score

    # @param password [String] password to evaluate
    def initialize(password)
      zxcvbn_result = Zxcvbn.test(password)
      @entropy = zxcvbn_result.entropy
      @score = zxcvbn_result.score
    end
  end
end
