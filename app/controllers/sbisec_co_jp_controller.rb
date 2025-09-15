class SbisecCoJpController < ApplicationController
  def index
    seeds = Passwords::Generators::DEFAULT_UPPERCASE_ALPHABETS +
      Passwords::Generators::DEFAULT_LOWERCASE_ALPHABETS +
      Passwords::Generators::DEFAULT_NUMBERS +
      Passwords::Generators::DEFAULT_SYMBOLS
    loop do
      @password = Passwords::Generators.create(size: 20, seeds: seeds)
      symbols_count = @password.chars.select { Passwords::Generators::DEFAULT_SYMBOLS.join.include?(it) }.count
      break unless symbols_count < 2
    end
    @entropy = Passwords::Generators.entropy(@password)
    @score = Passwords::Generators.score(@password)

    respond_to do |format|
      format.any do
        render layout: false, formats: [ :text ], content_type: "text/plain"
      end
      format.json do
        render layout: false, json: {
          password: @password, entropy: @entropy, score: @score
        }
      end
    end
  end
end
