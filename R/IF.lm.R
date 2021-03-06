#' Invisible Fence model selection (Linear Mixed Model)
#'
#' Invisible Fence model selection (Linear Mixed Model)
#'
#' @param full formular of full model
#' @param data data
#' @param B number of bootstrap sample, parametric for lmer
#' @param grid grid for c
#' @param fence fence method to be used, (adaptive, nonadaptive, more to add)
#' @param cn cn for nonadaptive
#' @param REML REML
#' @param bandwidth bandwidth for kernel smooth function
#' @return list with whatever
#' @export

IF.lm = function(
  full, data, B = 100, cpus = 2) {
  
  full = cleanformula(full) # remove random effect
  #my first comment
  # model fit function
  mf = lm
  # lack of fit function
  lf = function(res) abs(coef(res))[-1]  
  # bootstrap sample
  bs = bootstrap.lm(B, full, data)
  
  sfInit(parallel = TRUE, cpus = cpus) 
  sfExportAll()
  invisiblefence(mf, full, data, lf, bs)
}

RIF.lm = function(
  full, data, B = 100, cpus = 2) {
  ans = IF.lm(full, data, B, cpus)

  B = ans$B
  times = ans$freq * B
  size = 1:length(ans$freq)
  pvalues = sapply(size, function(i) pbirthday(B, choose(length(ans$freq), i), times[i]))

  ans$freq = NULL
  ans$pvalue = pvalues
  ans$size = which.min(pvalues)
  ans$model = ans$terms[1:ans$size]
  class(ans) = "RIF"
  ans
}

ad_hoc_relative = function(B, times, nogs, size) {
  ans = hugepbirthday(B, chooseZ(nogs, size), times)
  names(ans) = NULL
  ans
}


bootstrap.lm = function(B, full, data) {
  X = model.matrix(full, data)
  model = lm(full, data)
  sigma = summary(model)$sigma
  beta = coef(model)
  bootsmp = matrix(as.vector(X %*% beta) + rnorm(nrow(X) * B, 0, sigma), nrow = nrow(X))

  ans = replicate(B, data, FALSE)
  for (i in 1:B) {
    ans[[i]][,deparse(full[[2]])] = bootsmp[,i]
  }
  ans  
}

# TODO
cleanformula = function(f) {
  f
}
