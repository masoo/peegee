require "test_helper"

class JalCoJpControllerTest < ActionDispatch::IntegrationTest
  test "json response includes guesses_log10 and score" do
    get jal_co_jp_path(format: :json)

    assert_response :success
    assert_equal "application/json", response.media_type
    body = JSON.parse(response.body)
    assert body["password"].present?
    assert body.key?("guesses_log10")
    assert body.key?("score")
    assert_not body.key?("entropy")
  end

  test "text response includes guesses_log10 label" do
    get jal_co_jp_path

    assert_response :success
    assert_equal "text/plain", response.media_type
    assert_match(/guesses_log10:/, response.body)
    assert_no_match(/entropy:/, response.body)
  end

  test "generated password satisfies JAL password policy" do
    password = Www::JalCoJp.new.create
    symbols = Regexp.escape(Www::JalCoJp::JAL_SYMBOLS.join)

    assert_equal 32, password.length
    assert password.length >= 8, "must be at least 8 characters"
    types = [ /[A-Z]/, /[a-z]/, /[0-9]/, /[#{symbols}]/ ].count { |re| password.match?(re) }
    assert_equal 4, types, "must include uppercase, lowercase, numbers, and symbols"
  end

  test "generated password only uses allowed characters" do
    password = Www::JalCoJp.new.create
    allowed = Passwords::StandardGenerator::DEFAULT_UPPERCASE_ALPHABETS +
      Passwords::StandardGenerator::DEFAULT_LOWERCASE_ALPHABETS +
      Passwords::StandardGenerator::DEFAULT_NUMBERS +
      Www::JalCoJp::JAL_SYMBOLS

    assert_empty(password.chars - allowed, "password contains a disallowed character")
  end
end
