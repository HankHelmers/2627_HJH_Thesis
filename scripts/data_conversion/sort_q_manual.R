# sortQ from pop helper does not work currently
# This is a manual implementation 
sort_q_manual <- function(q_list) {

  q_list <- lapply(q_list, function(q) {

    # ensure numeric matrix/data.frame
    q <- as.data.frame(lapply(q, as.numeric))

    # dominant cluster per individual
    dom <- max.col(q, ties.method = "first")

    # order by dominant cluster, then by strength
    ord <- order(dom, -apply(q, 1, max))

    q[ord, , drop = FALSE]
  })

  return(q_list)
}
