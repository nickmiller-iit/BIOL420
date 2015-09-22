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

xorder.sampled <- function(coal){
  ancestors <- sort(ancestral_lineages(foo), decreasing = T)
  num_ancestors <- length(ancestors)
  complete <- rep(F, length(ancestors))
  sampled <- sampled_lineages(coal)
  curr_anc <- head(ancestors, 1)
  sampled_list <- vector(mode = 'integer')
  while(num_ancestors > 0){
    next_anc <- NA
    descendants <- sort(subset(coal, lineage_ancestor == curr_anc)$lineage)
    for (d in descendants){
      if (d %in% sampled){
        sampled_list <- c(sampled_list, d)
      }
      else{
        next_anc <- d
        break
      }
    }
    #ancestors <- ancestors[which(ancestors != curr_anc)]
    num_ancestors <- num_ancestors - 1
    idx <- which(ancestors == curr_anc)
    complete[idx] <- T
    if (is.na(next_anc)){
      #next_anc <- head(ancestors, 1)
      #incompletes <- ancestors[which(!complete)]
      pth <- path_to_MRCA(coal, curr_anc)
      #next_anc <- head(pth[which(pth %in% incompletes)], 1)
      for (anc in pth){
        found_it <- F
        descendants <- sort(subset(coal, lineage_ancestor == anc)$lineage)
        for (d in descendants){
          if (d %in% ancestors[which(!complete)]){
            found_it <- T
            next_anc <- d
            break
          }
        }
        if (found_it == T){
          break
        } 
      }
    }
    curr_anc <- next_anc
  }
  
  
  return(sampled_list)
}



get.xpos <- function(coal){
  #Easy enough, provided the sampled lineages can be ordered appropriately
  #Set positions of sampled lineages as inters 1:number_of_lineages
  #positions of ancestral lineages are the midpoints of their descendents
  #
  #start by ordering the sampled lineages
  lin <- xorder.sampled(coal)
  pos <- 1:length(lin)
  #add the ancestral lineages, positions initially set to 0
  ancestors <- ancestral_lineages(coal)
  pos <- c(pos, rep(0.0, length(ancestors)))
  lin <- c(lin, ancestors)
  #use sorting tricks to add an x_pos column to the coal dataframe
  coal$orig_order <- 1:length(coal[, 1]) #make sure we return with everything the same order
  positions <- data.frame(cbind(lin, pos))
  positions <- arrange(positions, lin)
  coal <- arrange(coal, lineage)
  coal$x_pos <- positions$pos
  #set the positions of ancestral lineages
  xpos_col <- which(names(coal) == "x_pos")
  for (anc in sort(ancestors)){
    r <- which(coal$lineage == anc)
    p <- mean(subset(coal, lineage_ancestor == anc)$x_pos)
    coal[r,xpos_col] <- p
  }
  #back to original sort order
  coal <- arrange(coal, orig_order)
  return(coal[, which(names(coal) != "orig_order")])
}

draw.tree <- function(coalescent){
  #draw a coalescent tree
  tree <- get.xpos(coalescent)
  ancestors <- ancestral_lineages(coalescent)
  height <- max(tree$lineage_end, na.rm=T)
  width <- max(tree$x_pos)
  #create the empty plot
  plot(x = tree$x_pos, 
       y = tree$lineage_end, 
       type = "n", 
       ylim = c(0, height * 1.05), 
       ylab = "generation", 
       xaxt = "n", 
       xlab = "")
  #draw the lineages
  for (lin in tree$lineage){
    l <- subset(tree, lineage == lin)
    lines(x = c(l$x_pos, l$x_pos), y = c(l$lineage_start, l$lineage_end))
  }
  #draw horizontal lines to show coalescences
  for (anc in ancestors){
    dec <- subset(tree, lineage_ancestor == anc)
    lines(x = dec$x_pos, y= dec$lineage_end)
  }
  
}
