#===============================================================================
# DCDencode
# dcdsplit.R
# Split trajectory into evenly sized files
# Requires 'catdcd' program (VMD software suite) 
# Usage: Rscript dcdsplit.R <traj> <first> <last> <nConf>
#===============================================================================

args = commandArgs(trailingOnly = TRUE)

## first argument is trajectory name
traj = args[1]
traj_name = unlist(strsplit(traj, "\\.", perl = TRUE))[1]

## second argument is first conformation, i.e. where to start splittig
first = abs(as.integer(args[2]))

## third argument is last conformation, i.e. where to end splittig
last = abs(as.integer(args[3]))

## fourth argument is target number of conformations in each output trajectory
nConf = abs(as.integer(args[4]))

error = tryCatch(stopifnot(nchar(args[1]) > 0, args[2] > 0, args[3] > 0, args[4] > 0),
  error = function(e) {
    ## stopifnot error message
    message(e)
    ## usage message
    message("\nUsage: 'Rscript dcdsplit.R <traj> <first> <last> <nConf>'")
    ## exit tryCatch with error code
    return(1)
  }
)
## stop if error code exists
if (! is.null(error)) { stop("Caught error in input arguments") }

#_______________________________________________________________________________
## number of output files with target number of conformations
nSplit = floor((last - first + 1) / nConf)
## additional output file for overhang conformations
isOverhang = as.numeric((last - first + 1) %% nConf != 0)

for (i in 0:(nSplit + isOverhang - 1)) {
  split_first = first + (i * nConf)
  ## last conformation must be larger than first
  stopifnot(last > split_first)
  split_last = min((split_first + nConf - 1), last)
  inname = sprintf("%s.dcd", traj_name)
  outname = sprintf("%s.%d-%d.dcd", traj_name, split_first, split_last)
  command = sprintf("catdcd -o %s -first %d -last %d %s",
                    outname, split_first, split_last, inname)
  message(command)
  system(command)
}

#===============================================================================
