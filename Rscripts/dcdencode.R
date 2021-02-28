#===============================================================================
# DCDencode 
# Read PDB structure and trajectory in local directory
# Encode trajectory and write SA strings as FASTA format
#===============================================================================

library("DCDencode")
library("bio3d")
library("pbapply")

## command line arguments
## argument [1] is input structure
## argument [2] is input trajectory
## argument [3] is conformation increment
args = commandArgs(trailingOnly = TRUE)

## by default no conformation increment (first conformation is '1 + confInc')
confInc = 0

#_______________________________________________________________________________
## argument [1] is input structure
#args[1] = "/mnt/databases/MD/PKM2/3BJT_monomer_apo/md0/3BJT_md0_ca.pdb"

if (! is.na(args[1])) {
  str = args[1]
  message("  The atom order and number of the input structure and input trajectory must match.\
  Please note that potential mis-matches are unlikely to be detected by DCDencode.")
} else {
  stop("Need input structure as first argument! Usage:\
  'Rscript dcdencode.R <str> <traj> <confInc>'")
}
message(paste("Input structure:", str))
## structure name
str_name = unlist(strsplit(str, "\\.", perl = TRUE))[1]
## read structure
str_bio3d = bio3d::read.pdb2(str)

#_______________________________________________________________________________
## argument [2] is input trajectory
#args[2] = "/mnt/databases/MD/PKM2/3BJT_monomer_apo/md0/3BJT_md0_ca.dcd"

if (! is.na(args[2])) {
  traj = args[2] 
} else {
  stop("Need input trajectory as second argument! Usage:\")
  'Rscript dcdencode.R <str> <traj> <confInc>'")
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
  message(paste("Output SA string numbering will start at #", confInc + 1))
} else {
  message("  Default setting: Output SA string numbering will start at #1.\
  For a different start number set conformation increment as third argument.\
  Example: If the first conformation is '51', set conformation increment to '50'.")
}

#_______________________________________________________________________________
## xyz indices of Calpha atoms only, gleaned from PDB structure
ca.inds = bio3d::atom.select(str_bio3d, "calpha")

## assertion that highest CA atom index is within number of xyz coordinates 
stopifnot("Highest CA atom index outside trajectory atom indices" = range(ca.inds$xyz)[2] <= dim(traj_bio3d)[2])

#_______________________________________________________________________________
## encode trajectory
message("Encoding trajectory")
## trajectory is matrix of dimension 3N columns (xyz) and timesteps rows
sa_string.v = encode(traj_bio3d[ , ca.inds$xyz])
sa_name.v = as.character(c(1:length(sa_string.v)) + confInc) 

outFile = paste(str_name, traj_name, "sasta", sep = '.')
message("Writing SA-encoded trajectory to '", outFile, "'.")
## Structural Alphabet sequence in FASTA format
sa_string.fasta = sprintf(">%s%s%s%s%s\n%s",
                          str_name, ".", traj_name, "|", sa_name.v, sa_string.v)
## write SA-encoded trajectory as FASTA file
write.table(sa_string.fasta, file = outFile,
				quote = FALSE, row.names = FALSE, col.names = FALSE)

#===============================================================================

