Andrew Fairless,  August 2011
modified May 2015 for posting onto Github
This script implements linear mixed models as reported in Fairless et al 2013
Fairless et al 2013,  doi: 10.1016/j.bbr.2012.08.051,  PMID: 22982070,  PMCID: PMC3554266

Since this script was originally written, the R package 'lme4' has been revised so that
this script no longer works.
Specifically, the attributes/fields of the linear mixed effects model produced by the 
function 'lmer' have been changed, so that the function 'pvals.fncaf' (altered from the
original 'pvals.fnc') can not access them (e.g., 'modelname@coefs' no longer exists).
A version of the old 'lme4' package exists as 'lme4.0'.  I was not able to get 'lme4.0'
to work with my code here.
See https://github.com/lme4/lme4/blob/master/misc/notes/release_notes.md
See http://cran.r-project.org/web/packages/lme4/README.html

The fictional data in "altereddata.txt" were modified from the original 
empirical data used in Fairless et al 2013.
I am using fictional data instead of the original data because I do not have 
permission of my co-authors to release the data into the public domain.  
NOTE:  Because these data are fictional, several important characteristics of
these data may be different from those of the original data (e.g., the litter
sex ratio and litter size differ for individual mice of the same litter, even 
though that is not possible with real, non-fictional data).

Data description:
Each row is a separate mouse.
Each column is a separate variable.
Strain, sex, and age are independent variables and fixed effects in the linear mixed models.
Cage and litter are independent varaibles and random effects in the linear mixed models.
From left to right, "nosesniff" to "nonsocial" are home cage behaviors and dependent variables.
From left to right, "chambtime" to "testfollowstim" are Social Approach/Choice Test behaviors 
and dependent variables.
