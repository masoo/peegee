# frozen_string_literal: true

class PasswordStrengthTool < ApplicationTool
  description "Evaluate the strength and security of a password"

  arguments do
    required(:password).filled(:string).description("The password to evaluate")
  end

  def call(password:)
    entropy = Passwords::Generators.entropy(password)
    score = Passwords::Generators.score(password)

    strength_level = case score
    when 0 then "Very Weak"
    when 1 then "Weak"
    when 2 then "Fair"
    when 3 then "Strong"
    when 4 then "Very Strong"
    else "Unknown"
    end

    recommendations = []

    if password.length < 12
      recommendations << "Consider using at least 12 characters"
    end

    unless password.match?(/[A-Z]/)
      recommendations << "Add uppercase letters for better security"
    end

    unless password.match?(/[a-z]/)
      recommendations << "Add lowercase letters for better security"
    end

    unless password.match?(/[0-9]/)
      recommendations << "Add numbers for better security"
    end

    unless password.match?(/[^A-Za-z0-9]/)
      recommendations << "Add special characters for better security"
    end

    if password.match?(/(.)\1{2,}/)
      recommendations << "Avoid repeating characters"
    end

    {
      password_length: password.length,
      entropy: entropy,
      score: score,
      strength_level: strength_level,
      has_uppercase: password.match?(/[A-Z]/),
      has_lowercase: password.match?(/[a-z]/),
      has_numbers: password.match?(/[0-9]/),
      has_symbols: password.match?(/[^A-Za-z0-9]/),
      recommendations: recommendations
    }
  end
end
