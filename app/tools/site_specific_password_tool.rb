# frozen_string_literal: true

class SiteSpecificPasswordTool < ApplicationTool
  description "Generate passwords for specific Japanese websites with their requirements"

  arguments do
    required(:site).filled(:string).description("Site name: sbi_securities, nenkinnet, kuroneko_members")
  end

  def call(site:)
    case site.downcase
    when "sbi_securities", "sbisec"
      generate_sbi_securities_password
    when "nenkinnet", "nenkin"
      generate_nenkinnet_password
    when "kuroneko_members", "kuroneko"
      generate_kuroneko_members_password
    when "smart_ex", "smartex"
      generate_smart_ex_password
    else
      {
        error: "Unknown site: #{site}",
        available_sites: [ "sbi_securities", "nenkinnet", "kuroneko_members", "smart_ex" ]
      }
    end
  end

  private

  def generate_sbi_securities_password
    seeds = Passwords::Generators::DEFAULT_UPPERCASE_ALPHABETS +
      Passwords::Generators::DEFAULT_LOWERCASE_ALPHABETS +
      Passwords::Generators::DEFAULT_NUMBERS +
      Passwords::Generators::DEFAULT_SYMBOLS

    password = nil
    symbols_count = 0

    loop do
      password = Passwords::Generators.create(size: 20, seeds: seeds, excluded: [])
      symbols_count = password.chars.count { |c| Passwords::Generators::DEFAULT_SYMBOLS.include?(c) }
      break unless symbols_count < 2
    end

    {
      site: "SBI Securities",
      password: password,
      length: password.length,
      entropy: Passwords::Generators.entropy(password),
      score: Passwords::Generators.score(password),
      requirements: {
        length: "20 characters",
        must_include: "At least 2 special characters",
        character_types: "Uppercase, lowercase, numbers, and symbols"
      },
      symbols_count: symbols_count
    }
  end

  def generate_nenkinnet_password
    seeds = Passwords::Generators::DEFAULT_UPPERCASE_ALPHABETS +
      Passwords::Generators::DEFAULT_LOWERCASE_ALPHABETS +
      Passwords::Generators::DEFAULT_NUMBERS

    password = Passwords::Generators.create(size: 20, seeds: seeds, excluded: [])

    {
      site: "Nenkin Net",
      password: password,
      length: password.length,
      entropy: Passwords::Generators.entropy(password),
      score: Passwords::Generators.score(password),
      requirements: {
        length: "20 characters",
        character_types: "Uppercase, lowercase, and numbers (no symbols)"
      }
    }
  end

  def generate_kuroneko_members_password
    seeds = Passwords::Generators::DEFAULT_UPPERCASE_ALPHABETS +
      Passwords::Generators::DEFAULT_LOWERCASE_ALPHABETS

    password = Passwords::Generators.create(size: 12, seeds: seeds, excluded: [])

    {
      site: "Kuroneko Members",
      password: password,
      length: password.length,
      entropy: Passwords::Generators.entropy(password),
      score: Passwords::Generators.score(password),
      requirements: {
        length: "12 characters",
        character_types: "Uppercase and lowercase letters only (no numbers or symbols)"
      }
    }
  end

  def generate_smart_ex_password
    password = Www::SmartExJp.create

    {
      site: "Smart EX",
      password: password,
      length: password.length,
      entropy: Passwords::Generators.entropy(password),
      score: Passwords::Generators.score(password),
      requirements: {
        length: "8 characters",
        character_types: "Uppercase, lowercase, numbers, and symbols"
      }
    }
  end
end
