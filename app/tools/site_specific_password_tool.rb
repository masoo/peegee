# frozen_string_literal: true

class SiteSpecificPasswordTool < ApplicationTool
  description "Generate passwords for specific Japanese websites with their requirements"

  arguments do
    required(:site).filled(:string).description("Site name: sbi_securities, nenkinnet, kuroneko_members, rakuten_bank")
  end

  def call(site:)
    case site.downcase
    when "sbi_securities", "sbisec"
      generate_password(generator: Www::SbisecCoJp.new, site: "SBI Securities")
    when "nenkinnet", "nenkin"
      generate_password(generator: Www::NenkinGoJp.new, site: "Nenkin Net")
    when "kuroneko_members", "kuroneko"
      generate_password(generator: Www::KuronekoyamatoCoJp.new, site: "Kuroneko Members")
    when "smart_ex", "smartex"
      generate_password(generator: Www::SmartExJp.new, site: "Smart EX")
    when "rakuten_bank"
      generate_password(generator: Www::RakutenBankCoJp.new, site: "Rakuten Bank")
    else
      {
        error: "Unknown site: #{site}",
        available_sites: [ "sbi_securities", "nenkinnet", "kuroneko_members", "smart_ex", "rakuten_bank" ]
      }
    end
  end

  private

  # Generic method to generate password for a given site generator
  def generate_password(generator:, site:)
    generator.create
    evaluator = Passwords::StrengthEvaluator.new(generator.password)

    {
      site: site,
      password: generator.password,
      length: generator.password.length,
      entropy: evaluator.entropy,
      score: evaluator.score,
      requirements: generator.requirements
    }
  end
end
