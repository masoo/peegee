# WWW domains
module Www
  # @note クロネコメンバーズ (Kuroneko Members) のパスワードポリシーに準拠したパスワードを生成する
  #     - 8～15文字
  #     - 数字、アルファベット、記号のうち、2種類以上の組み合わせが必要
  class KuronekoyamatoCoJp
    attr_reader :password

    PASSWORD_LENGTH = 15
    KURONEKO_SYMBOLS = '!#$%&\'-^@./`{+*}?_'.chars
    SEEDS = Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS +
      Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS +
      Passwords::StandardGenerator::DEFAULT_NUMBERS +
      KURONEKO_SYMBOLS

    # initialize
    def initialize
      @password = nil
    end

    # Generate a kuronekoyamato.co.jp compliant password
    # @return [String] password
    def create
      return @password if @password

      generators = Array.new(4) { Passwords::StandardGenerator.new }
      generators[0].create(size: 1, seeds: (Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS + Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS))
      generators[1].create(size: 1, seeds: Passwords::StandardGenerator::DEFAULT_NUMBERS)
      generators[2].create(size: 1, seeds: KURONEKO_SYMBOLS)
      generators[3].create(size: PASSWORD_LENGTH - 3, seeds: SEEDS)
      base_characters = generators[0].password.chars + generators[1].password.chars + generators[2].password.chars + generators[3].password.chars
      @password = base_characters.shuffle.join
    end

    # LLM requirements
    # @return [Hash] requirements
    def requirements
      {
        length: {
          min: 8,
          max: 15,
          default: PASSWORD_LENGTH,
          current: @password&.length
        },
        character_sets: {
          letters: {
            required: true,
            characters: (Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS + Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS).join,
            description: "半角英字（大文字・小文字）"
          },
          numbers: {
            required: true,
            characters: Passwords::StandardGenerator::DEFAULT_NUMBERS.join,
            description: "半角数字"
          },
          symbols: {
            required: true,
            characters: KURONEKO_SYMBOLS.join,
            description: "使用可能な記号"
          }
        },
        rules: [
          "8～15文字",
          "数字、アルファベット、記号のうち、2種類以上の組み合わせが必要"
        ],
        url: "https://faq.kuronekoyamato.co.jp/app/answers/detail/a_id/7554/"
      }
    end
  end
end
