require "securerandom"

# password domain
module Passwords
  # standard password generator
  class StandardGenerator
    attr_reader :password

    DEFAULT_PASSWORD_LENGTH = 32
    DEFAULT_UPPERCASE_ALPHABETS = [ *"A".."Z" ]
    DEFAULT_LOWERCASE_ALPHABETS = [ *"a".."z" ]
    DEFAULT_NUMBERS = [ *"0".."9" ]
    DEFAULT_SYMBOLS = '!"#$%&\'()*+,-./:;<=>?@[\]^_`{|}~'.chars
    DEFAULT_SEEDS = DEFAULT_UPPERCASE_ALPHABETS + DEFAULT_LOWERCASE_ALPHABETS + DEFAULT_NUMBERS + DEFAULT_SYMBOLS
    EXCLUDE_LOOK_ALIKE_CHARACTERS = "0oO1lI|gq9".chars

    # initialize
    def initialize
      @password = nil
    end

    # Generate a standard password
    # @param [integer] size - password length
    # @param [Charactor Array] seeds - password seed's charactors
    # @return [String] password
    def create(size: DEFAULT_PASSWORD_LENGTH, seeds: DEFAULT_SEEDS, excluded: EXCLUDE_LOOK_ALIKE_CHARACTERS)
      return @password if @password
      values = seeds - excluded
      @password = size.times.map { values.sample(random: SecureRandom) }.join
    end
  end
end
