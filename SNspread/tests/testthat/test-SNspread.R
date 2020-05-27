library('SNspread')
library('matrixcalc')

context("Core SNspread functionality")

test_that("create_network returns matrix of correct size", {

  n <- 15
  test_network1 <- create_network(n = n)

  expect_equal(nrow(test_network1), (n + 1))
  expect_equal(ncol(test_network1), (n + 3))
})

test_that("create_network includes a bidirectional weight matrix", {

  test_network2 <- create_network()
  test_network_matrix <- as.matrix(test_network2[1:11, 1:11])

  expect_equal(matrixcalc::is.symmetric.matrix(test_network_matrix), TRUE)
})

test_that("sim_spread infects nodes with spread_rate", {

  test_network3 <- create_network(n = 20)
  spread_rate <- 3

  test_network3v1 <- sim_spread(test_network3, spread_rate = spread_rate)
  test_network3v2 <- sim_spread(test_network3v1, spread_rate = spread_rate)
  test_network3v3 <- sim_spread(test_network3v2, spread_rate = spread_rate)

  expect_equal(sum(test_network3v1$disease == "infected"), 1)
  expect_equal(sum(test_network3v2$disease == "infected"), 4)
  expect_equal(sum(test_network3v3$disease == "infected"), 16)

})

test_that("sim_spread stops infecting when all nodes are infected", {

  test_network4 <- create_network(n = 8)
  spread_rate <- 5

  test_network4v1 <- sim_spread(test_network4, spread_rate = spread_rate)
  test_network4v2 <- sim_spread(test_network4v1, spread_rate = spread_rate)

  expect_warning(sim_spread(test_network4v2, spread_rate = spread_rate))

})
