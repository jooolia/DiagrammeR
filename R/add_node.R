#' Add a node to an existing graph object
#' @description With a graph object of class \code{dgr_graph}, add a new node
#' of a specified type to extant nodes within the graph.
#' @param graph a graph object of class \code{dgr_graph} that is created using
#' \code{create_graph}.
#' @param node a node ID for the newly connected node.
#' @param from an optional vector containing node IDs from which edges will be
#' directed to the new node.
#' @param to an optional vector containing node IDs to which edges will be
#' directed from the new node.
#' @param label a character object for supplying an optional label to the node.
#' Setting to \code{TRUE} ascribes the node ID to the label. Setting to
#' \code{FALSE} yields a blank label.
#' @param type an optional string that describes the entity type for the node
#' to be added.
#' @param ... one or more vectors pertaining to node attributes.
#' @return a graph object of class \code{dgr_graph}.
#' @examples
#' \dontrun{
#' # Create an empty graph
#' graph <- create_graph()
#'
#' # Add two nodes
#' graph <- add_node(graph, node = "a")
#' graph <- add_node(graph, node = "b")
#' }
#' @export add_node

add_node <- function(graph,
                     node,
                     from = NULL,
                     to = NULL,
                     label = TRUE,
                     type = NULL,
                     ...){

  # Verify that 'node' is given as a single value
  node_is_single_value <- ifelse(length(node) == 1, TRUE, FALSE)

  # Stop function if node not a single value
  if (node_is_single_value == FALSE){

    stop("Only a single node can be added.")
  }

  # Determine whether node to add is already in graph
  if (node_is_single_value == TRUE){

    can_add_node_id <-
      ifelse(!node_present(graph = graph, node = node), TRUE, FALSE)
  }

  if (can_add_node_id == FALSE){

    return(graph)
  }

  # Place triple dot vectors in a list
  node_attributes <- list(...)

  # Determine whether optional node attributes provided
  node_attributes_provided <-
    ifelse(length(node_attributes) > 0, TRUE, FALSE)

  # Modify graph if only 'from' values provided
  if (!is.null(from) & is.null(to)){

    from_nodes_available <-
      ifelse(all(from %in% get_nodes(graph)), TRUE, FALSE)

    if (from_nodes_available == FALSE){

      stop("The nodes from which edges should be applied to the new node are not available.")
    }

    if (from_nodes_available){

      combined_nodes <-
        combine_nodes(graph$nodes_df,
                      create_nodes(nodes = node,
                                   label = label,
                                   type = ifelse(is.null(type), "", type)))

      if (node_attributes_provided == TRUE){

        for (i in 1:length(node_attributes)){

          if (names(node_attributes)[i] %in% colnames(combined_nodes)){

            combined_nodes[nrow(combined_nodes),
                           which(colnames(combined_nodes) ==
                                   names(node_attributes)[i])] <-
              node_attributes[i][[1]]
          }

          if (!(names(node_attributes)[i] %in% colnames(combined_nodes))){

            combined_nodes <-
              cbind(combined_nodes,
                    c(rep("", length = nrow(combined_nodes) - 1),
                      node_attributes[i][[1]]))

            colnames(combined_nodes)[ncol(combined_nodes)] <-
              names(node_attributes)[i]
          }
        }
      }

      if (!is.null(graph$edges_df)){

        combined_edges <-
          combine_edges(graph$edges_df,
                        create_edges(from = from,
                                     to = rep(node, length(from))))

        dgr_graph <-
          create_graph(nodes_df = combined_nodes,
                       edges_df = combined_edges,
                       graph_attrs = graph$graph_attrs,
                       node_attrs = graph$node_attrs,
                       edge_attrs = graph$edge_attrs,
                       graph_name = graph$graph_name,
                       graph_time = graph$graph_time,
                       graph_tz = graph$graph_tz)
      }

      if (is.null(graph$edges_df)){

        dgr_graph <-
          create_graph(nodes_df = combined_nodes,
                       edges_df = create_edges(from = from,
                                               to = rep(node, length(from))),
                       graph_attrs = graph$graph_attrs,
                       node_attrs = graph$node_attrs,
                       edge_attrs = graph$edge_attrs,
                       graph_name = graph$graph_name,
                       graph_time = graph$graph_time,
                       graph_tz = graph$graph_tz)
      }

      # Return the revised graph
      return(dgr_graph)
    }
  }

  # Modify graph if only 'to' values provided
  if (is.null(from) & !is.null(to)){

    to_nodes_available <- ifelse(all(to %in% get_nodes(graph)), TRUE, FALSE)

    if (to_nodes_available == FALSE){

      stop("The nodes to which edges should be applied from the new node are not available.")
    }

    combined_nodes <-
      combine_nodes(graph$nodes_df,
                    create_nodes(nodes = node,
                                 label = label,
                                 type = ifelse(is.null(type), "", type)))

    if (node_attributes_provided == TRUE){

      for (i in 1:length(node_attributes)){

        if (names(node_attributes)[i] %in% colnames(combined_nodes)){

          combined_nodes[nrow(combined_nodes),
                         which(colnames(combined_nodes) ==
                                 names(node_attributes)[i])] <-
            node_attributes[i][[1]]
        }

        if (!(names(node_attributes)[i] %in% colnames(combined_nodes))){

          combined_nodes <-
            cbind(combined_nodes,
                  c(rep("", length = nrow(combined_nodes) - 1),
                    node_attributes[i][[1]]))

          colnames(combined_nodes)[ncol(combined_nodes)] <-
            names(node_attributes)[i]
        }
      }

      combined_edges <-
        combine_edges(graph$edges_df,
                      create_edges(from = rep(node, length(to)),
                                   to = to))

      # Create the revised graph object
      dgr_graph <-
        create_graph(nodes_df = combined_nodes,
                     edges_df = combined_edges,
                     graph_attrs = graph$graph_attrs,
                     node_attrs = graph$node_attrs,
                     edge_attrs = graph$edge_attrs,
                     graph_name = graph$graph_name,
                     graph_time = graph$graph_time,
                     graph_tz = graph$graph_tz)

      # Create a revised graph and return that graph
      return(dgr_graph)
    }

    if (!is.null(graph$edges_df)){

      combined_edges <-
        combine_edges(graph$edges_df,
                      create_edges(from = rep(node, length(to)),
                                   to = to))

      dgr_graph <-
        create_graph(nodes_df = combined_nodes,
                     edges_df = combined_edges,
                     graph_attrs = graph$graph_attrs,
                     node_attrs = graph$node_attrs,
                     edge_attrs = graph$edge_attrs,
                     graph_name = graph$graph_name,
                     graph_time = graph$graph_time,
                     graph_tz = graph$graph_tz)
    }

    if (is.null(graph$edges_df)){

      dgr_graph <-
        create_graph(nodes_df = combined_nodes,
                     edges_df = create_edges(from = rep(node, length(to)),
                                             to = to),
                     graph_attrs = graph$graph_attrs,
                     node_attrs = graph$node_attrs,
                     edge_attrs = graph$edge_attrs,
                     graph_name = graph$graph_name,
                     graph_time = graph$graph_time,
                     graph_tz = graph$graph_tz)
    }

    # Return the revised graph
    return(dgr_graph)
  }

  # Modify graph if both 'to' and 'from' values provided
  if (!is.null(from) & !is.null(to)){

    from_nodes_available <- ifelse(all(from %in% get_nodes(graph)), TRUE, FALSE)

    to_nodes_available <- ifelse(all(to %in% get_nodes(graph)), TRUE, FALSE)

    if (from_nodes_available == FALSE){

      stop("The nodes from which edges should be applied to the new node are not available.")
    }

    if (to_nodes_available == FALSE){

      stop("The nodes to which edges should be applied from the new node are not available.")
    }

    if (from_nodes_available & to_nodes_available){

      combined_nodes <-
        combine_nodes(graph$nodes_df,
                      create_nodes(nodes = node,
                                   label = label,
                                   type = ifelse(is.null(type), "", type)))

      if (node_attributes_provided == TRUE){

        for (i in 1:length(node_attributes)){

          if (names(node_attributes)[i] %in% colnames(combined_nodes)){

            combined_nodes[nrow(combined_nodes),
                           which(colnames(combined_nodes) ==
                                   names(node_attributes)[i])] <-
              node_attributes[i][[1]]
          }

          if (!(names(node_attributes)[i] %in% colnames(combined_nodes))){

            combined_nodes <-
              cbind(combined_nodes,
                    c(rep("", length = nrow(combined_nodes) - 1),
                      node_attributes[i][[1]]))

            colnames(combined_nodes)[ncol(combined_nodes)] <-
              names(node_attributes)[i]
          }
        }
      }

      if (!is.null(graph$edges_df)){

        combined_edges_1 <-
          combine_edges(graph$edges_df,
                        create_edges(from = from,
                                     to = rep(node, length(from))))
      }

      if (is.null(graph$edges_df)){

        combined_edges_1 <-
          create_edges(from = from,
                       to = rep(node, length(from)))
      }

      if (!is.null(graph$edges_df)){

        combined_edges_2 <-
          combine_edges(combined_edges,
                        create_edges(from = rep(node, length(to)),
                                     to = to))
      }

      if (is.null(graph$edges_df)){

        combined_edges_2 <-
          create_edges(from = rep(node, length(to)),
                       to = to)
      }

      combined_edges <-
        combine_edges(combined_edges_1,
                      combined_edges_2)

      # Create the revised graph object
      dgr_graph <-
        create_graph(nodes_df = combined_nodes,
                     edges_df = combined_edges,
                     graph_attrs = graph$graph_attrs,
                     node_attrs = graph$node_attrs,
                     edge_attrs = graph$edge_attrs,
                     graph_name = graph$graph_name,
                     graph_time = graph$graph_time,
                     graph_tz = graph$graph_tz)

      # Create a revised graph and return that graph
      return(dgr_graph)
    }
  }

  # Modify graph if none of 'to' nor 'from' values provided
  if (is.null(from) & is.null(to)){
    if (!is.null(type)){
      if (!is.null(graph$nodes_df)){

        combined_nodes <-
          combine_nodes(graph$nodes_df,
                        create_nodes(nodes = node,
                                     label = label,
                                     type = type))
      } else {
        combined_nodes <-
          create_nodes(nodes = node,
                       label = label,
                       type = type)
      }
    }

    if (is.null(type)){
      if (!is.null(graph$nodes_df)){

        combined_nodes <-
          combine_nodes(graph$nodes_df,
                        create_nodes(nodes = node,
                                     label = label))
      } else {
        combined_nodes <-
          create_nodes(nodes = node,
                       label = label)
      }
    }

    if (node_attributes_provided == TRUE){

      for (i in 1:length(node_attributes)){

        if (names(node_attributes)[i] %in% colnames(combined_nodes)){

          combined_nodes[nrow(combined_nodes),
                         which(colnames(combined_nodes) ==
                                 names(node_attributes)[i])] <-
            node_attributes[i][[1]]
        }

        if (!(names(node_attributes)[i] %in% colnames(combined_nodes))){

          combined_nodes <-
            cbind(combined_nodes,
                  c(rep("", length = nrow(combined_nodes) - 1),
                    node_attributes[i][[1]]))

          colnames(combined_nodes)[ncol(combined_nodes)] <-
            names(node_attributes)[i]
        }
      }

      # Create a revised graph and return that graph
      dgr_graph <-
        create_graph(nodes_df = combined_nodes,
                     edges_df = graph$edges_df,
                     graph_attrs = graph$graph_attrs,
                     node_attrs = graph$node_attrs,
                     edge_attrs = graph$edge_attrs,
                     graph_name = graph$graph_name,
                     graph_time = graph$graph_time,
                     graph_tz = graph$graph_tz)

      return(dgr_graph)
    }

    if (node_attributes_provided == FALSE){

      # Create a revised graph and return that graph
      dgr_graph <-
        create_graph(nodes_df = combined_nodes,
                     edges_df = graph$edges_df,
                     graph_attrs = graph$graph_attrs,
                     node_attrs = graph$node_attrs,
                     edge_attrs = graph$edge_attrs,
                     graph_name = graph$graph_name,
                     graph_time = graph$graph_time,
                     graph_tz = graph$graph_tz)

      return(dgr_graph)
    }
  }
}
