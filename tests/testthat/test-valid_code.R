test_that("valid_code_format works", {
  expect_equal(valid_code_format("333333"), TRUE)
  expect_equal(valid_code_format("k33333"), FALSE)
  expect_equal(valid_code_format("33333"), FALSE)
})
