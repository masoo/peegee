module Www
  # @note 楽天銀行のパスワードポリシーに準拠したパスワードを生成する
  #      - 8文字以上12文字以内
  #      - 以下4種類の文字のすべてを含む
  #          1) 英大文字
  #          2) 英小文字
  #          3) 数字
  #          4) 記号
  #             $-./:@[]_#&?
  # @url https://www.rakuten-bank.co.jp/guide/etc/password.html
  class RakutenBankCoJp
    attr_reader :password

    PASSWORD_LENGTH = 12
    RAKUTEN_SYMBOLS = "$-./:@[]_#&?".chars
    SEEDS = Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS +
      Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS +
      Passwords::StandardGenerator::DEFAULT_NUMBERS +
      RAKUTEN_SYMBOLS

    # initialize
    def initialize
      @password = nil
    end

    # Generate a rakuten-bank.co.jp compliant password
    # @return [String] password
    def create
      return @password if @password

      generators = Array.new(5) { Passwords::StandardGenerator.new }
      generators[0].create(size: 1, seeds: Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS)
      generators[1].create(size: 1, seeds: Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS)
      generators[2].create(size: 1, seeds: Passwords::StandardGenerator::DEFAULT_NUMBERS)
      generators[3].create(size: 1, seeds: RAKUTEN_SYMBOLS)
      generators[4].create(size: PASSWORD_LENGTH - 4, seeds: SEEDS)
      base_characters = generators.flat_map { |generator| generator.password.chars }
      @password = base_characters.shuffle.join
    end

    # LLM requirements
    # @return [Hash] requirements
    def requirements
      {
        length: {
          min: 8,
          max: 12,
          default: PASSWORD_LENGTH,
          current: @password&.length
        },
        character_sets: {
          uppercase: {
            required: true,
            min_count: 1,
            characters: Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS.join,
            description: "英大文字"
          },
          lowercase: {
            required: true,
            min_count: 1,
            characters: Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS.join,
            description: "英小文字"
          },
          numbers: {
            required: true,
            min_count: 1,
            characters: Passwords::StandardGenerator::DEFAULT_NUMBERS.join,
            description: "数字"
          },
          symbols: {
            required: true,
            min_count: 1,
            characters: RAKUTEN_SYMBOLS.join,
            description: "記号（$-./:@[]_#&?）"
          }
        },
        rules: [
          "8文字以上12文字以内",
          "英大文字を1文字以上含む",
          "英小文字を1文字以上含む",
          "数字を1文字以上含む",
          "記号（$-./:@[]_#&?）を1文字以上含む"
        ],
        url: "https://www.rakuten-bank.co.jp/guide/etc/password.html"
      }
    end
  end
end
