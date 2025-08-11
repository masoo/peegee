# frozen_string_literal: true

class PasswordGeneratorTool < ApplicationTool
  description "Generate a secure password with customizable options"

  arguments do
    optional(:length).filled(:integer).description("Password length (default: 32)")
    optional(:include_uppercase).filled(:bool).description("Include uppercase letters (default: true)")
    optional(:include_lowercase).filled(:bool).description("Include lowercase letters (default: true)")
    optional(:include_numbers).filled(:bool).description("Include numbers (default: true)")
    optional(:include_symbols).filled(:bool).description("Include symbols (default: true)")
    optional(:exclude_lookalike).filled(:bool).description("Exclude lookalike characters like 0,o,O,1,l,I,|,g,q,9 (default: true)")
  end

  def call(
    length: 32,
    include_uppercase: true,
    include_lowercase: true,
    include_numbers: true,
    include_symbols: true,
    exclude_lookalike: true
  )
    seeds = []
    seeds += Passwords::Generators::DEFAULT_UPPERCASE_ALPHABETS if include_uppercase
    seeds += Passwords::Generators::DEFAULT_LOWERCASE_ALPHABETS if include_lowercase
    seeds += Passwords::Generators::DEFAULT_NUMBERS if include_numbers
    seeds += Passwords::Generators::DEFAULT_SYMBOLS if include_symbols

    if seeds.empty?
      return { error: "At least one character type must be included" }
    end

    excluded = exclude_lookalike ? Passwords::Generators::EXCLUDE_LOOK_ALIKE_CHARACTERS : []

    password = Passwords::Generators.create(
      size: length,
      seeds: seeds,
      excluded: excluded
    )

    {
      password: password,
      length: password.length,
      entropy: Passwords::Generators.entropy(password),
      score: Passwords::Generators.score(password),
      options: {
        include_uppercase: include_uppercase,
        include_lowercase: include_lowercase,
        include_numbers: include_numbers,
        include_symbols: include_symbols,
        exclude_lookalike: exclude_lookalike
      }
    }
  end
end
