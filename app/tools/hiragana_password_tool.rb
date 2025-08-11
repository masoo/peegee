# frozen_string_literal: true

class HiraganaPasswordTool < ApplicationTool
  description "Generate a password using only hiragana characters (for Japanese sites)"

  arguments do
    optional(:length).filled(:integer).description("Password length (default: 32)")
  end

  def call(length: 32)
    password = Passwords::Generators.create_hiragana_password(size: length)

    {
      password: password,
      length: password.length,
      entropy: Passwords::Generators.entropy(password),
      score: Passwords::Generators.score(password),
      type: "hiragana",
      description: "Password generated using only hiragana characters (あ-ん)"
    }
  end
end
