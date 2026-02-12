test_that("code_get form check", {
  skip_if_offline()

  code <- code_get(TRUE, sample = TRUE, bas_dd = "2024-01-02")
  col <- names(code)
  expect_true("market" %in% col)
  expect_true("name" %in% col)
  expect_true("code" %in% col)
  expect_true("name_full" %in% col)
  expect_true("name_eng" %in% col)
  expect_true("code_full" %in% col)
  expect_gt(nrow(code), 0)
})
