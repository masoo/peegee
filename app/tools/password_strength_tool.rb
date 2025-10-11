# frozen_string_literal: true

class PasswordStrengthTool < ApplicationTool
  description "Evaluate the strength and security of a password"

  arguments do
    required(:password).filled(:string).description("The password to evaluate")
  end

  def call(password:)
    entropy = Passwords::Generators.entropy(password)
    score = Passwords::Generators.score(password)
    password_chars = password.chars

    {
      password_length: password.length,
      entropy: entropy,
      score: score,
      options: {
        include_uppercase: password_chars.any? { |char| Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS.include?(char) },
        include_lowercase: password_chars.any? { |char| Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS.include?(char) },
        include_numbers: password_chars.any? { |char| Passwords::StandardGenerator::DEFAULT_NUMBERS.include?(char) },
        include_symbols: password_chars.any? { |char| Passwords::StandardGenerator::DEFAULT_SYMBOLS.include?(char) },
        exclude_lookalike: password_chars.any? { |char| Passwords::StandardGenerator::EXCLUDE_LOOK_ALIKE_CHARACTERS.include?(char) }
      }
    }
  end
end
