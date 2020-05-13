
# User input --------------------------------------------------------------



# Make graph --------------------------------------------------------------

#' @export
create_graph <- function (n = 10){# n is number of friends
  # Make edgelist
  friends = paste("friend", 1:n, sep = "")

  edgelist = data.frame(
    input = rep("user", n),
    output = friends,
    connection = rep(1,n))

  # Simulate some additional friendships
  n_friendships = sample(1:n, 1)
  edgelist2 = data.frame(
    input = friends[sample(1:n, n_friendships)],
    output = friends[sample(1:n, n_friendships)],
    connection = rep(1,n_friendships)
  )

  # Complete edgelist
  edgelist = rbind(edgelist, edgelist2)

  # plot graph
  qgraph::qgraph(edgelist, color = c("red", "blue"))

  # Use colors for spread, create new graph where everybody is contaminated.
  qgraph::qgraph(edgelist, color = c("red"))
}


