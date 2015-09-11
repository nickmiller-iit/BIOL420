coalesce.discrete <- function(two.N, k){
  p <- ((k*(k-1))/2) * (1/two.N);
  return(rgeom(1, p));
}

sim.coal <- function(two.N, k){
  cur_lineages <- 1:k
  lineages <- leaves
  ancestor <- k + 1
  height = 0
  start <- numeric(length = k)
  end <- numeric(length = k)
  ancestor <- numeric(length = k)
  while(length(lineages > 1)){
    t.next <- coalesce.discrete(two.N, length(cur_lineages))
    to_coal <- sample(cur_lineages, 2)
    
  }


}