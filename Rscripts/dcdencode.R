#===============================================================================
# DCDencode 
# Read PDB structure and trajectory in local directory
# Encode trajectory and write SA strings as FASTA format
#===============================================================================

library("DCDencode")
library("bio3d")

## command line arguments
## argument [1] is input structure
## argument [2] is input trajectory
## argument [3] is conformation increment
args = commandArgs(trailingOnly = TRUE)

## default increment (assuming first conformation is '1')
confInc = 0

#_______________________________________________________________________________
## argument [1] is input structure
if (! is.na(args[1])) {
  str = args[1]
} else {
  stop("Need input structure as first argument!")
}
message(paste("Input structure:", str))
## structure name
str_name = unlist(strsplit(str, "\\.", perl = TRUE))[1]
## read structure
str_bio3d = bio3d::read.pdb2(str)

#_______________________________________________________________________________
## argument [2] is input trajectory
if (! is.na(args[2])) {
  traj = args[2] 
} else {
  stop("Need input trajectory as second argument!")
}

message(paste("Input trajectory:", traj))
## trajectory name
traj_name = unlist(strsplit(traj, "\\.", perl = TRUE))[1]
## read structure
traj_bio3d = bio3d::read.dcd(traj)

#_______________________________________________________________________________
## argument [3] is conformation increment if trajectory has been split
## the increment is added to the conformation number
if (! is.na(args[3])) {
  confInc = as.numeric(args[3])
  paste("Output SA strings start at conformation", confInc + 1)
} else {
  message("Default setting: Output SA strings start at conformation '1'.\
          For a different start number set conformation increment as third argument.\
          Example: If first conformation is '51', set conformation increment to '50'.")
}

#_______________________________________________________________________________
## xyz indices of Calpha atoms only, gleaned from PDB structure
ca.inds = bio3d::atom.select(str_bio3d, "calpha")

#_______________________________________________________________________________
## encode trajectory
## trajectory is matrix of dimension 3N columns (xyz) and timesteps rows
sa_string.v = encode(traj_bio3d[ , ca.inds$xyz])
sa_name.v = as.character(c(1:length(sa_string.v)) + confInc) 
## Structural Alphabet sequence in FASTA format
sa_string.fasta = sprintf(">%s%s%s%s%s\n%s",
                          str_name, ".", traj_name, "|", sa_name.v, sa_string.v)

## write SA-encoded trajectory as FASTA file
outFile = paste(str_name, traj_name, "sasta", sep = '.')
write.table(sa_string.fasta, file = outFile,
				quote = FALSE, row.names = FALSE, col.names = FALSE)
message("Output SA strings have been written to '", outFile, "'.")

#===============================================================================

