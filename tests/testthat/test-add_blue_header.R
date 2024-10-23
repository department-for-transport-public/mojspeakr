# Mock function to replace conditional_publishing_output for testing
local_mocked_bindings(
  conditional_publishing_output = function(output, publication_type) {
    return(output)
  }
)

# Test cases for the add_blue_header function
test_that("add_blue_header generates correct HTML structure", {

  # Test default appearance
  result <- add_blue_header("Test Header")

  # Expect the result to include correct default parameters
  expect_true(
    grepl(
      "<span style='color: white; font-family: Arial; font-weight: normal;'>\nNational Statistics\n</span>",
      result
    )
  )
  # expect_true(
  #   grepl(
  #     "<h1>\\s*<span style='color: white; font-family: Arial;font-size: 50px; font-weight: bold;'>Test Header</span>\\s*</h1>",
  #     result
  #   )
  # )
  # expect_true(
  #   grepl(
  #     "<h3>\\s*<span style='color: white; font-family: Arial; font-weight: bold;'>Pre-release</span>\\s*</h3>",
  #     result
  #   )
  # )

  # Test with custom inputs
  result_custom <- add_blue_header(
    header_text = "Custom Header",
    stats_status = "Custom Statistics",
    pre_release_note = "Custom Pre-release"
  )

  expect_true(
    grepl(
      "Custom Header</span>",
      result_custom,
      fixed = TRUE

    )
  )
  # expect_true(
  #   grepl(
  #     "<h1>\\s*<span style='color: white; font-family: Arial;font-size: 50px; font-weight: bold;'>Custom Header</span>\\s*</h1>",
  #     result_custom
  #   )
  # )
  # expect_true(
  #   grepl(
  #     "<h3>\\s*<span style='color: white; font-family: Arial; font-weight: bold;'>Custom Pre-release</span>\\s*</h3>",
  #     result_custom
  #   )
  # )

  })

