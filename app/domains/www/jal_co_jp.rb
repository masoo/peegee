module Www
  # @note JAL（JALマイレージバンク／JMB）のパスワードポリシーに準拠したパスワードを生成する
  #      - 8文字以上（文字数の上限は公表されていない）
  #      - 以下4種類のうち2種類以上を含む
  #          1) 英大文字
  #          2) 英小文字
  #          3) 数字
  #          4) 記号
  #      - 大文字・小文字は区別される
  # @note 使用できる記号は公式ページで公表されている（下記 JAL_SYMBOLS を参照）。
  #       英大文字・英小文字・数字・記号の4種類すべてを1文字以上含めて生成し、2種類以上の要件を確実に満たす。
  # @url https://www.jal.co.jp/jp/ja/jmb/jmb-login/password/
  class JalCoJp
    attr_reader :password

    PASSWORD_LENGTH = 32
    # 公式に公表されている使用可能な半角記号: ! " # $ % & ( ) + , - . / : ; < = > @ [ ] ^ _ {
    JAL_SYMBOLS = '!"#$%&()+,-./:;<=>@[]^_{'.chars
    SEEDS = Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS +
      Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS +
      Passwords::StandardGenerator::DEFAULT_NUMBERS +
      JAL_SYMBOLS

    # initialize
    def initialize
      @password = nil
    end

    # Generate a jal.co.jp compliant password
    # @return [String] password
    def create
      return @password if @password

      generators = Array.new(5) { Passwords::StandardGenerator.new }
      generators[0].create(size: 1, seeds: Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS)
      generators[1].create(size: 1, seeds: Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS)
      generators[2].create(size: 1, seeds: Passwords::StandardGenerator::DEFAULT_NUMBERS)
      generators[3].create(size: 1, seeds: JAL_SYMBOLS)
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
          max: nil,
          default: PASSWORD_LENGTH,
          current: @password&.length
        },
        character_sets: {
          uppercase: {
            required: false,
            characters: Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS.join,
            description: "半角英大文字"
          },
          lowercase: {
            required: false,
            characters: Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS.join,
            description: "半角英小文字"
          },
          numbers: {
            required: false,
            characters: Passwords::StandardGenerator::DEFAULT_NUMBERS.join,
            description: "半角数字"
          },
          symbols: {
            required: false,
            characters: JAL_SYMBOLS.join,
            description: "公式に公表されている使用可能な半角記号"
          }
        },
        rules: [
          "8文字以上（文字数の上限なし）",
          "英大文字・英小文字・数字・記号の4種類のうち2種類以上を含む",
          "大文字・小文字は区別される",
          "本ジェネレーターは4種類すべてを含む32文字を生成する",
          "使用できる記号: #{JAL_SYMBOLS.join}"
        ],
        url: "https://www.jal.co.jp/jp/ja/jmb/jmb-login/password/"
      }
    end
  end
end
