# Create network ----------------------------------------------------------

#' Create initial network
#'
#' This function creates a network based on the amount of friends a user inputs.
#'
#' @param n Numeric vector of length 1. Is the number of friends in network.
#'
#' @return Data frame including weight matrix from the network,
#'         infection status and gender of nodes (friends) in network.
#'
#' @examples
#' network <- create_network(n = 15)
#' create_graph(network)
#'
#' @details
#' This function creates a network with user and his/her friends as nodes,
#' edges between user and friends, and random edges between some friends.
#'
#' @export
create_network <- function (n = 10) {

  # Make weight list
  weight_matrix <- data.frame(matrix(data = 0, nrow = (n + 1), ncol = (n + 3)))
  rownames(weight_matrix) = c("user", paste("friend", 1:n, sep = ""))
  colnames(weight_matrix) = c("user", paste("friend", 1:n, sep = ""), "disease", "gender")

  # Make connection between user and friends
  weight_matrix["user", 2:(n+1)] <- 1
  weight_matrix[2:(n+1), "user"] <- 1

  # Simulate some additional bidirectional friendships
  n_friendships <- sample(1:((n * (n - 1)) / 2), 1)
  for (i in 1:n_friendships) {

    new_friends <- sample(1:n, 2)
    weight_matrix[(1 + new_friends[1]), (1 + new_friends[2])] <- 1
    weight_matrix[(1 + new_friends[2]), (1 + new_friends[1])] <- 1

  }

  # Remove connection with self
  diag(weight_matrix[1:(n + 1), 1:(n + 1)]) <- 0

  return(weight_matrix)
}


#' Update network
#'
#' This function updates the gender and names of nodes in a network, based
#' user input.
#'
#' @param weigth_matrix Data frame including weight matrix from a network,
#'                      infection status and gender of nodes in network.
#'
#' @param gender Numeric vector of size number of people,
#'               with 2 indicating women and 1 indicating men.
#' @param names Character vector with names of user and friends,
#'              starting with user. Any number of names can be added,
#'              up to the number of nodes in the network.
#'
#' @return Data frame including weight matrix from the network,
#'         infection status and gender of nodes in network.
#'
#' @examples
#' network <- create_network(n = 15)
#' network2 <- update_network(network,
#'                            gender = c(sample(c(0,1), 16, replace = TRUE)))
#' create_graph(network2)
#'
#' @details
#' This function creates a new version of a network with user and his/her
#' friends as nodes, edges between user and friends, and an updated name
#' of friends and/or addition of gender.
#'
#' @export
update_network <- function (weight_matrix, gender = NULL, names = NULL) {

  # Add gender
  if (!is.null(gender)) {
    if (length(gender) != length(weight_matrix$gender)) {

      stop("length of gender vector is not the same as number of people in network")

    } else {

      weight_matrix$gender = gender

    }
  }

  # Update names
  if (!is.null(names)) {

    rownames(weight_matrix)[1:(length(names))] = names
    colnames(weight_matrix)[1:(length(names))] = names

  }

  return(weight_matrix)
}


# Create graph for network ------------------------------------------------

#' Create graph based on network
#'
#' @param weight_matrix Data frame including weight matrix from a network,
#'                      infection status and gender of nodes in network.
#'
#' @export
create_graph <- function (weight_matrix) {

  # Plot graph
  qgraph::qgraph(weight_matrix[, 1:(ncol(weight_matrix) - 2)],
                 color = c("gray", "red"),
                 groups = weight_matrix[, "disease"],
                 label.color = ifelse(weight_matrix$gender == 0,
                                      "black",
                                      ifelse(weight_matrix$gender == 1, "blue", "pink")),
                 edge.color = "blue")
}


# Simulate spread of disease ----------------------------------------------

#' Simulate spread of disease in network
#'
#' @param weight_matrix Data frame including weight matrix from a network,
#'                      infection status and gender of nodes in network.
#'
#' @param spread_rate Integer that states how many nodes in network should
#'                    be infected.
#'
#' @export
sim_spread <- function (weight_matrix, spread_rate = 2) {

  # Make sure user inputs spread_rate as integer
  if (spread_rate%%1 != 0) {

    stop("spread_rate should be an integer")

  }

  # Simulate spread
  if (all(weight_matrix$disease == 0)) {

    # Infect user first
    weight_matrix$disease[1] <- "infected"
    weight_matrix$disease <- as.factor(weight_matrix$disease)

  } else if (all(weight_matrix$disease == "infected")) {

    # Warning for user if all nodes are already infected
    warning("All friends are already infected.")

  } else {

    # Infect nodes connected to already infected nodes
    for (node in grep("infected", weight_matrix$disease)) {

      # Search for connected nodes
      temp_sample <- grep(1, weight_matrix[node, 1:nrow(weight_matrix)])

      # Remove already infected nodes
      temp_sample <- temp_sample[weight_matrix$disease[temp_sample] != "infected"]

      # Check if there are uninfected nodes in sample
      if (length(temp_sample) >= spread_rate) {

        # Infect nodes if infected node is connected to others
        weight_matrix$disease[sample(temp_sample, spread_rate)] <-"infected"

      # Check if there are enough uninfected nodes left
      } else if (length(grep(0, weight_matrix$disease)) <= spread_rate) {

        # Infect everyone who is left and return
        weight_matrix$disease[weight_matrix$disease == 0] <-"infected"

        # Warning for user if all nodes are already infected
        warning("All friends are infected.")

        return(weight_matrix)

      } else {

        # Infect random node
        weight_matrix$disease[sample(grep(0, weight_matrix$disease), spread_rate)] <-"infected"

      }
    }
  }

  return(weight_matrix)
}
