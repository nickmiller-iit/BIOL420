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

ancestral_lineages <- function(coal){
  #return the lineages that are ancestral
  return(coal$lineage[which(coal$lineage %in% coal$lineage_ancestor)])
}

sampled_lineages <- function(coal){
  #return the sampled lineages
  return(coal$lineage[which(!(coal$lineage %in% ancestral_lineages(coal)))])
}

path_to_MRCA <- function(coal, lineage){
  #returns all the ancestral lineages from a specified lineag back to the MRCA
  #including the lineage itself and the MRCA
  path <- lineage
  completed = F
  while (!completed){
    anc <- subset(coal, lineage == tail(path, 1))$lineage_ancestor
    if (is.na(anc)){
      completed <- T
    }
    else{
      path <- c(path, anc)
    }
  }
  return(path)
}

get.xpos <- function (coalescent){
  #Oddly, this was the hardest bit to figure out. This wokrs, but is probably not optimal
  #
  #basic problem: we need to se the x positions of the samples lineages such that
  #coalescing lineages are always adjacent to each other.
  #
  #Solution: count up the number of descendants each lineage has. Each sampled lineage
  #is assigned a score computed by summing the number of descendants for each 
  #ancestral lineage back to the MRCA. Sampled lineages are ranked by score to get
  #their relative xpositions. Ranking is then used to assign the absolute x position.
  #
  #For ancestral lineages, the x position is simply the midpoint of its 2 descencents
  #
  #
  coal <- coalescent
  #ensure we return in the same sort order we recieved
  coal$original_order <- 1:length(coal[,1])
  #compute number of descendants for each lineage
  coal$descendants <- rep(0, length(coal[,1]))
  desc_col <- which(names(coal) == "descendants")
  for (lin in sort(ancestral_lineages(coal))){
    descendent_count <-sum(subset(coal, lineage_ancestor == lin)$descendants) + 2
    coal[which(coal$lineage == lin),desc_col] <- descendent_count
  }
  #compute scores for sampled lineages
  coal$score <- rep(0, length(coal[,1]))
  score_col <- which(names(coal) == "score")
  for (lin in sort(sampled_lineages(coal))){
    score <- sum(subset(coal, lineage %in% path_to_MRCA(coal, lin))$descendants)
    coal[which(coal$lineage == lin), score_col] <- score
  }
  #use scores to set x positions of sampled lineages
  coal <- arrange(coal, score, lineage)
  coal$x_pos <- c(rep(0, length(ancestral_lineages(coal))), 1:length(sampled_lineages(coal)))
  xpos_col <- which(names(coal) == "x_pos")
  #set x positions of ancestral lineages
  for (lin in ancestral_lineages(coal)){
    x <- mean(subset(coal, lineage_ancestor == lin)$x_pos)
    coal[which(coal$lineage == lin), xpos_col] <- x

  }
  #back to original order
  coal <- arrange(coal, original_order)
  #get rid of intermediate cols
  coal <- coal[, which(!(names(coal) %in% c("original_order", "descendants", "score")))]
  return(coal)
}

