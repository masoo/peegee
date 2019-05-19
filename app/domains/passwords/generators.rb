require 'securerandom'
require 'zxcvbn'

module Passwords
  class Generators
    class << self
      def default
        lowercase_alphabets = [*'a'..'z']
        upcase_alphabets = [*'A'..'Z']
        symbols = '!"#$%&\'()*+,-./:;<=>?@[\]^_`{|}~'.split('')
        seeds = lowercase_alphabets + upcase_alphabets + symbols
        password = 32.times.map { seeds.sample }.join
      end

      def entropy(password)
        Zxcvbn.test(password).entropy
      end

      def score(password)
        Zxcvbn.test(password).score
      end

      def hiragana
        hiragana = [*'あ'..'ん']
        seeds = hiragana
        password = 32.times.map { seeds.sample }.join
      end
    end
  end
end