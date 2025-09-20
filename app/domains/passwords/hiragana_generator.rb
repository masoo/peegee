require "securerandom"

module Passwords
  # Hiragana password generator
  class HiraganaGenerator
    attr_reader :password

    DEFAULT_PASSWORD_LENGTH = 32
    HIRAGANA_CHARACTERS = [ *"あ".."ん" ]

    # initialize
    def initialize
      @password = nil
    end

    # Generate a hiragana password
    # @param [integer] size - password length
    # @return [String] password
    def create(size: DEFAULT_PASSWORD_LENGTH, seeds: HIRAGANA_CHARACTERS, excluded: [])
      return @password if @password
      values = seeds - excluded
      size.times.map { values.sample(random: SecureRandom) }.join
    end
  end
end
