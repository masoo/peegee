module Www
  # @note 年金ネットのパスワードポリシーに準拠したパスワードを生成する
  #      - 20文字の英数字
  #      - 記号は使用不可
  # @url https://www.nenkin.go.jp/faq/n_net/kihonsosa/id-password/20120731.html
  class NenkinGoJp
    attr_reader :password

    PASSWORD_LENGTH = 20
    SEEDS = Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS +
      Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS +
      Passwords::StandardGenerator::DEFAULT_NUMBERS

    # initialize
    def initialize
      @password = nil
    end

    # Generate a nenkin.go.jp compliant password
    # @return [String] password
    def create
      return @password if @password

      generator = Passwords::StandardGenerator.new
      @password = generator.create(size: PASSWORD_LENGTH, seeds: SEEDS)
    end

    # LLM requirements
    # @return [Hash] requirements
    def requirements
      {
        length: {
          min: 8,
          max: 20,
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
          }
        },
        rules: [
          "20文字",
          "英字（大文字・小文字）と数字を含む",
          "記号は使用不可"
        ],
        url: "https://www.nenkin.go.jp/faq/n_net/kihonsosa/id-password/20120731.html"
      }
    end
  end
end
