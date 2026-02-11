test_that("krx_service_list crawls OPPINFO004 services", {
  skip_if_offline()

  svc <- krx_service_list()

  expect_gt(nrow(svc), 0)
  expect_true(any(svc$api_name == "유가증권 일별매매정보"))
  expect_true(all(c("category", "api_name", "bo_id", "detail_url") %in% names(svc)))
})

test_that("krx_service_spec parses api id and fields", {
  skip_if_offline()

  spec <- krx_service_spec("JvJFzlAENzZlPBDNGAWC")

  expect_equal(spec$api_id, "stk_bydd_trd")
  expect_true("basDd" %in% spec$input$name)
  expect_true("TDD_CLSPRC" %in% spec$output$name)
})
