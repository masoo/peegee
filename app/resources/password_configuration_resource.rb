# frozen_string_literal: true

class PasswordConfigurationResource < ApplicationResource
  uri "password/configuration"
  resource_name "Password Configuration"
  description "Available password generation options and site-specific requirements"
  mime_type "application/json"

  def content
    JSON.generate({
      general_options: {
        default_length: 32,
        available_lengths: (8..128).to_a,
        character_types: {
          uppercase: "A-Z",
          lowercase: "a-z",
          numbers: "0-9",
          symbols: '!"#$%&\'()*+,-./:;<=>?@[\]^_`{|}~'
        },
        lookalike_characters: "0oO1lI|gq9",
        entropy_levels: {
          very_weak: "< 25",
          weak: "25-50",
          fair: "50-75",
          strong: "75-100",
          very_strong: "> 100"
        },
        score_levels: {
          0 => "Very Weak",
          1 => "Weak",
          2 => "Fair",
          3 => "Strong",
          4 => "Very Strong"
        }
      },
      japanese_options: {
        hiragana: {
          characters: "あ-ん",
          total_count: 46,
          description: "Suitable for Japanese sites requiring hiragana passwords"
        }
      },
      site_specific_requirements: {
        sbi_securities: {
          name: "SBI証券",
          length: 20,
          required_types: [ "uppercase", "lowercase", "numbers", "symbols" ],
          special_requirement: "Must include at least 2 special characters",
          site_url: "https://www.sbisec.co.jp"
        },
        nenkinnet: {
          name: "ねんきんネット",
          length: 20,
          required_types: [ "uppercase", "lowercase", "numbers" ],
          forbidden_types: [ "symbols" ],
          site_url: "https://www.nenkin.go.jp"
        },
        kuroneko_members: {
          name: "クロネコメンバーズ",
          length: 12,
          required_types: [ "uppercase", "lowercase" ],
          forbidden_types: [ "numbers", "symbols" ],
          site_url: "https://www.kuronekoyamato.co.jp"
        },
        smart_ex: {
          name: "スマートEX",
          length: 8,
          required_types: [ "uppercase", "lowercase", "numbers", "symbols" ],
          site_url: "https://www.smart-ex.jp"
        },
        rakuten_bank: {
          name: "楽天銀行",
          length: 12,
          required_types: [ "uppercase", "lowercase", "numbers", "symbols" ],
          allowed_symbols: "$-./:@[]_#&?",
          special_requirement: "Must use only specific symbols: $-./:@[]_#&?",
          site_url: "https://www.rakuten-bank.co.jp/guide/etc/password.html"
        }
      },
      recommendations: {
        minimum_length: 12,
        recommended_length: 16,
        best_practice_length: 20,
        use_all_character_types: true,
        avoid_personal_information: true,
        unique_per_site: true,
        regular_rotation: "3-6 months for sensitive accounts"
      }
    })
  end
end
