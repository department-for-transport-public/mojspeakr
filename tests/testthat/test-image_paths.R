test_that("Expected number of image references are found", {
  lines <-  readLines("../test_files/test.md")
  img_ref <- generate_image_references(lines)
  expect_equal(nrow(img_ref), 3)

})

test_that("Image references are not duplicates", {
  lines <-  readLines("../test_files/test.md")
  img_ref <- generate_image_references(lines)
  expect_length(unique(img_ref$img_tags), 3)
})

test_that("Govspeak tags are as expected", {
  lines <-  readLines("../test_files/test.md")
  img_ref <- generate_image_references(lines)
  expect_identical(img_ref$govspeak, c("!!1", "!!2", "!!3"))
})
