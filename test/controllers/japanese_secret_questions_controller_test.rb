require "test_helper"

class JapaneseSecretQuestionsControllerTest < ActionDispatch::IntegrationTest
  test "json response includes guesses_log10 and score" do
    get japanese_secret_questions_path(format: :json)

    assert_response :success
    assert_equal "application/json", response.media_type
    body = JSON.parse(response.body)
    assert body["password"].present?
    assert body.key?("guesses_log10")
    assert body.key?("score")
    assert_not body.key?("entropy")
  end

  test "text response includes guesses_log10 label" do
    get japanese_secret_questions_path

    assert_response :success
    assert_equal "text/plain", response.media_type
    assert_match(/guesses_log10:/, response.body)
    assert_no_match(/entropy:/, response.body)
  end
end
