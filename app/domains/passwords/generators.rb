require "securerandom"
require "zxcvbn"

module Passwords
  class Generators
    DEFAULT_PASSWORD_LENGTH = 32
    DEFAULT_UPPERCASE_ALPHABETS = [ *"A".."Z" ]
    DEFAULT_LOWERCASE_ALPHABETS = [ *"a".."z" ]
    DEFAULT_NUMBERS = [ *"0".."9" ]
    DEFAULT_SYMBOLS = '!"#$%&\'()*+,-./:;<=>?@[\]^_`{|}~'.split("")
    DEFAULT_SEEDS = DEFAULT_UPPERCASE_ALPHABETS + DEFAULT_LOWERCASE_ALPHABETS + DEFAULT_NUMBERS + DEFAULT_SYMBOLS
    EXCLUDE_LOOK_ALIKE_CHARACTERS = "0oO1lI|gq9".split("")

    class << self
      # Generate a standard password
      # @param [integer] size - password length
      # @param [Charactor Array] seeds - password seed's charactors
      # @return [String] password
      def create(size: DEFAULT_PASSWORD_LENGTH, seeds: DEFAULT_SEEDS, excluded: EXCLUDE_LOOK_ALIKE_CHARACTERS)
        values = seeds - excluded
        size.times.map { values.sample }.join
      end

      def entropy(password)
        Zxcvbn.test(password).entropy
      end

      def score(password)
        Zxcvbn.test(password).score
      end

      # Generate a hiragana password
      # @param [integer] size - password length
      # @return [String] password
      def create_hiragana_password(size: DEFAULT_PASSWORD_LENGTH)
        hiragana = [ *"あ".."ん" ]
        seeds = hiragana
        password = size.times.map { seeds.sample }.join
      end
    end
  end
end
