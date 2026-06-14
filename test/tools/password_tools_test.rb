require "test_helper"

class PasswordToolsTest < ActiveSupport::TestCase
  test "PasswordGeneratorTool returns guesses_log10 and score instead of entropy" do
    result = PasswordGeneratorTool.new.call(length: 16)

    assert result[:password].present?
    assert_kind_of Numeric, result[:guesses_log10]
    assert_includes 0..4, result[:score]
    assert_not result.key?(:entropy)
  end

  test "HiraganaPasswordTool returns guesses_log10 and score" do
    result = HiraganaPasswordTool.new.call(length: 16)

    assert result[:password].present?
    assert_kind_of Numeric, result[:guesses_log10]
    assert_includes 0..4, result[:score]
    assert_not result.key?(:entropy)
  end

  test "SiteSpecificPasswordTool returns guesses_log10 and score" do
    result = SiteSpecificPasswordTool.new.call(site: "sbisec")

    assert result[:password].present?
    assert_kind_of Numeric, result[:guesses_log10]
    assert_includes 0..4, result[:score]
    assert_not result.key?(:entropy)
  end

  test "PasswordStrengthTool evaluates a given password with guesses_log10" do
    result = PasswordStrengthTool.new.call(password: "correct horse battery staple")

    assert_equal 28, result[:password_length]
    assert_kind_of Numeric, result[:guesses_log10]
    assert_includes 0..4, result[:score]
    assert_not result.key?(:entropy)
  end
end
