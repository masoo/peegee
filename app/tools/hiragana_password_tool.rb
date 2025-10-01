# frozen_string_literal: true

class HiraganaPasswordTool < ApplicationTool
  description "Generate a password using only hiragana characters (for Japanese sites)"

  arguments do
    optional(:length).filled(:integer).description("Password length (default: 32)")
  end

  def call(length: 32)
    generator = Passwords::HiraganaGenerator.new
    password = generator.create(size: length)
    evaluator = Passwords::StrengthEvaluator.new(password)

    {
      password: password,
      length: password.length,
      entropy: evaluator.entropy,
      score: evaluator.score,
      type: "hiragana",
      description: "Password generated using only hiragana characters (あ-ん)"
    }
  end
end
