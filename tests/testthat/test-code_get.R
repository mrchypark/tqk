test_that("code_get form check", {

  skip_if_offline()

  code <- code_get(TRUE)
  col <- names(code)
  expect_true("market" %in% col)
  expect_true("name" %in% col)
  expect_true("code" %in% col)
  expect_gt(nrow(code), 0)
})
