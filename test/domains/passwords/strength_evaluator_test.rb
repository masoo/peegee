require "test_helper"

module Passwords
  class StrengthEvaluatorTest < ActiveSupport::TestCase
    test "exposes guesses_log10 and score from zxcvbn" do
      evaluator = Passwords::StrengthEvaluator.new("correct horse battery staple")

      assert_kind_of Numeric, evaluator.guesses_log10
      assert evaluator.guesses_log10.positive?
      assert_includes 0..4, evaluator.score
    end

    test "weak password yields lower guesses_log10 than strong password" do
      weak = Passwords::StrengthEvaluator.new("123456")
      strong = Passwords::StrengthEvaluator.new("9Xk#2vQ!pZ7mL@4w")

      assert_operator weak.guesses_log10, :<, strong.guesses_log10
    end

    test "no longer responds to the removed entropy method" do
      evaluator = Passwords::StrengthEvaluator.new("password")

      assert_not_respond_to evaluator, :entropy
    end
  end
end
