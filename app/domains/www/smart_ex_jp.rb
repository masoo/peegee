require "securerandom"
require "zxcvbn"

module Www
  # @note 英数記号4-8桁 のパスワードが許容されるため、8桁のパスワードを生成する
  class SmartExJp
    PASSWORD_LENGTH = 8
    SEEDS = Passwords::Generators::DEFAULT_UPPERCASE_ALPHABETS +
      Passwords::Generators::DEFAULT_LOWERCASE_ALPHABETS +
      Passwords::Generators::DEFAULT_NUMBERS +
      Passwords::Generators::DEFAULT_SYMBOLS

    class << self
      def create
        Passwords::Generators.create(size: PASSWORD_LENGTH, seeds: SEEDS)
      end
    end
  end
end
