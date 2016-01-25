# Andrew Fairless,  August 2011
# modified May 2015 for posting onto Github
# This script implements linear mixed models as reported in Fairless et al 2013
# Fairless et al 2013,  doi: 10.1016/j.bbr.2012.08.051,  PMID: 22982070,  PMCID: PMC3554266

# Since this script was originally written, the R package 'lme4' has been revised so that
# this script no longer works.
# Specifically, the attributes/fields of the linear mixed effects model produced by the 
# function 'lmer' have been changed, so that the function 'pvals.fncaf' (altered from the
# original 'pvals.fnc') can not access them (e.g., 'modelname@coefs' no longer exists).
# A version of the old 'lme4' package exists as 'lme4.0'.  I was not able to get 'lme4.0'
# to work with my code here.
# See https://github.com/lme4/lme4/blob/master/misc/notes/release_notes.md
# See http://cran.r-project.org/web/packages/lme4/README.html

# The fictional data in "altereddata.txt" were modified from the original 
# empirical data used in Fairless et al 2013.
# I am using fictional data instead of the original data because I do not have 
# permission of my co-authors to release the data into the public domain.  
# NOTE:  Because these data are fictional, several important characteristics of
# these data may be different from those of the original data (e.g., the litter
# sex ratio and litter size differ for individual mice of the same litter, even 
# though that is not possible with real, non-fictional data).

# Data description:
# Each row is a separate mouse.
# Each column is a separate variable.
# Strain, sex, and age are independent variables and fixed effects in the linear mixed models.
# Cage and litter are independent varaibles and random effects in the linear mixed models.
# From left to right, "nosesniff" to "nonsocial" are home cage behaviors and dependent variables.
# From left to right, "chambtime" to "testfollowstim" are Social Approach/Choice Test behaviors 
# and dependent variables.

# install.packages("lme4", dependencies = TRUE)     # install package if not already installed
install.packages("lme4.0", type = "both", 
                 repos = c("http://lme4.r-forge.r-project.org/repos", 
                           getOption("repos")[["CRAN"]]))

library(lme4)
source("pvals.fncaf.txt")

data = read.table("altereddata.txt", header = TRUE)
data = split(data, data$age)[[1]]                # includes only 30-day-old mice; excludes 41- and 69-day-old mice

# specifies statistical models
modelcalls = "a"
modelcalls[1] = "data[ , iter] ~ (strain + sex)^2 + (1|cage) + (1|litter)"
modelcalls[2] = "data[ , iter] ~ (strain + sex)^2 + (1|cage)"

depvarcolstart = 9                                # left-most column/dependent variable to include in analysis
depvarcolstop = 22                                # right-most column/dependent variable to include in analysis
depvarn = depvarcolstop - (depvarcolstart - 1)    # number of columns/dependent variables to include in analysis
maxnumberfixef = 6                                # maximum number of fixed effects in any of the specified statistical models

# sets up template table of p values for each dependent variable
ptable = NA
ptable = as.data.frame(ptable)
ptable[ , 1:(2 * (depvarn))] = NA
ptable[1:maxnumberfixef, ] = NA
colnames(ptable)[1:depvarn] = 
     paste(colnames(data)[depvarcolstart:depvarcolstop], "pmc", sep = "")
colnames(ptable)[(depvarn + 1):(depvarn * 2)] = 
     paste(colnames(data)[depvarcolstart:depvarcolstop], "pt", sep = "")

# sets up table of p values for each statistical model
output = list()[1:length(modelcalls)]
names(output) = modelcalls
for (iter in 1:length(modelcalls)) {
     output[[iter]] = ptable
}

# calculates p values for the linear mixed effects models for each dependent variable
# and saves the p values to a table 'output'
for (iter2 in 1:length(modelcalls)) {                                      # loop iterates along each specificied statistical model
     for (iter in depvarcolstart:depvarcolstop) {                          # loop iterates along each dependent variable
          model = lmer(modelcalls[iter2], data = data)                     # fits linear mixed effects model to data
          modelpvals = pvals.fncaf(model, nsim = 10000, addPlot = FALSE)   # calculates p values of fixed effects using MCMC method
          if (iter ==  depvarcolstart) {
               output[[iter2]] = ptable[1:(dim(modelpvals$fixed)[1] - 1), ]
          }
          output[[iter2]][ , (iter - (depvarcolstart - 1))] = as.numeric(modelpvals$fixed[2:dim(modelpvals$fixed)[1], 5])
          output[[iter2]][ , ((iter - (depvarcolstart - 1)) + depvarn)] = as.numeric(modelpvals$fixed[2:dim(modelpvals$fixed)[1], 6])
     }
     rownames(output[[iter2]]) = rownames(modelpvals$fixed)[2:dim(modelpvals$fixed)[1]]
}
