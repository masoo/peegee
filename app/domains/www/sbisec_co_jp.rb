module Www
  # @note SBI証券のパスワードポリシーに準拠したパスワードを生成する
  #      - 10文字以上20文字以内
  #      - 以下3種類の文字のすべてを含む
  #          1) 半角英字(1文字以上)
  #          2) 半角数字(1文字以上)
  #          3) 特定の記号を2種類以上
  # @url https://www.sbisec.co.jp/ETGate/WPLETmgR001Control?OutSide=on&getFlg=on&burl=search_home&cat1=home&cat2=service&dir=service&file=home_security_password.html
  class SbisecCoJp
    attr_reader :password

    PASSWORD_LENGTH = 20
    SBI_SYMBOLS = '!"#$%&\'()*+,-./:;<=>?@[]^_`{|}~'.chars
    SEEDS = Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS +
      Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS +
      Passwords::StandardGenerator::DEFAULT_NUMBERS +
      SBI_SYMBOLS

    # initialize
    def initialize
      @password = nil
    end

    # Generate a sbisec.co.jp compliant password
    # @return [String] password
    def create
      return @password if @password

      generators = Array.new(4) { Passwords::StandardGenerator.new }
      generators[0].create(size: 2, seeds: SBI_SYMBOLS)
      generators[1].create(size: 1, seeds: Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS + Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS)
      generators[2].create(size: 1, seeds: Passwords::StandardGenerator::DEFAULT_NUMBERS)
      generators[3].create(size: PASSWORD_LENGTH - 4, seeds: SEEDS)
      base_characters = generators[0].password.chars + generators[1].password.chars + generators[2].password.chars + generators[3].password.chars
      @password = base_characters.shuffle.join
    end

    ## LLM requirements
    # @return [Hash] requirements
    def requirements
      {
        length: {
          min: 10,
          max: 20,
          default: PASSWORD_LENGTH,
          current: @password&.length
        },
        character_sets: {
          letters: {
            required: true,
            min_count: 1,
            characters: (Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS + Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS).join,
            description: "半角英字（大文字・小文字のいずれか）"
          },
          numbers: {
            required: true,
            min_count: 1,
            characters: Passwords::StandardGenerator::DEFAULT_NUMBERS.join,
            description: "半角数字"
          },
          symbols: {
            required: true,
            min_count: 2,
            characters: SBI_SYMBOLS.join,
            description: "特定の記号を2種類以上"
          }
        },
        rules: [
          "10文字以上20文字以内",
          "半角英字を1文字以上含む（大文字・小文字は区別）",
          "半角数字を1文字以上含む",
          "使用可能な記号を2種類以上含む"
        ],
        url: "https://www.sbisec.co.jp/ETGate/WPLETmgR001Control?OutSide=on&getFlg=on&burl=search_home&cat1=home&cat2=service&dir=service&file=home_security_password.html"
      }
    end
  end
end
