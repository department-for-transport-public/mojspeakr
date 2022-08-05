test_that("bolding works with and without punctuation", {
  expect_identical(bold_key_words("increase"), "**increase**")
  expect_identical(bold_key_words("(increase)"), "(**increase**)")
  expect_identical(bold_key_words("increasely"), "increasely")
})

test_that("bolding key words can be added", {
  expect_identical(bold_key_words("chicken", key_words = "chicken"), "**chicken**")
  expect_identical(bold_key_words("chicken-nugs", key_words = "chicken"), "**chicken**-nugs")
  expect_identical(bold_key_words("chickening", key_words = "chicken"), "chickening")
})

test_that("bolding key words can be removed", {
  expect_identical(bold_key_words("increase", key_words_remove = "increase"), "increase")
  expect_identical(bold_key_words("increased", key_words_remove = "increase"), "**increased**")
})
