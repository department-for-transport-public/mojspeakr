test_that("default substitution works as expected", {
  expect_identical(hash_sub("##", sub_type = TRUE), "###")
  expect_identical(hash_sub("###", sub_type = TRUE), "####")
  expect_identical(hash_sub("## This is text", sub_type = TRUE), "### This is text")
})

test_that("false sub_type does nothing", {
  expect_identical(hash_sub("##", sub_type = FALSE), "##")
  expect_identical(hash_sub("###", sub_type = FALSE), "###")
  expect_identical(hash_sub("## This is text", sub_type = FALSE), "## This is text")
})

test_that("selecting which strings to sub works", {
  expect_identical(hash_sub("## ", sub_type = c("#|##")), "### ")
  expect_identical(hash_sub("### ", sub_type = c("#|##")), "### ")
  expect_identical(hash_sub("## This is text", sub_type = c("#|##")), "### This is text")
})
