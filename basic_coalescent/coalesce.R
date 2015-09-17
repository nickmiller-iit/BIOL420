library(plyr)

coalesce.discrete <- function(two.N, k){
  p <- ((k*(k-1))/2) * (1/two.N);
  return(rgeom(1, p));
}

sim.coal <- function(two.N, k){
  #set up
  height <- 0 #height of the tree
  lineage <- 1:k #present day lineages
  active_lineages <- lineage #track the active lineages
  lineage_start <- rep(0, length(lineage))
  lineage_end <- rep(NA, length(lineage))
  lineage_ancestor <- rep(NA, length(lineage))
  next_ancestor <- max(lineage) #will get incremented when we enter the while loop
  
  #coalesce to mrca
  while (length(active_lineages) > 1){ 
    next_coal <- coalesce.discrete(two.N, length(active_lineages))
    height <- height + next_coal
    next_ancestor <- next_ancestor + 1
    to_coalesce <- sample(active_lineages, 2) #get the lineages that will coalesce
    #update end time and ancestor for chosen lineages
    for (idx in which(lineage %in% to_coalesce)){
      lineage_end[idx] <- height
      lineage_ancestor[idx] <- next_ancestor
    }
    #add the ancestral lineage
    lineage <- c(lineage, next_ancestor)
    lineage_start <- c(lineage_start, height)
    lineage_end <- c(lineage_end, NA)
    lineage_ancestor <- c(lineage_ancestor, NA)
    active_lineages <- c(active_lineages, next_ancestor)
    #remove the coalesced lineages from the active list
    active_lineages <- active_lineages[which(!(active_lineages %in% to_coalesce))]
  }
  return(data.frame(cbind(lineage, lineage_start, lineage_end, lineage_ancestor)))
}