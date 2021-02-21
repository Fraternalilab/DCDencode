#===============================================================================
# DCDencode 
# Read PDB structure and trajectory in local directory
# Encode trajectory and write SA strings as FASTA format
#===============================================================================

library("DCDencode")
library("bio3d")

args = commandArgs(trailingOnly = TRUE)
args[1] = "3BJT_md0_ca.pdb"
args[2] = "3BJT_md0_ca.dcd"

#_______________________________________________________________________________
## input structure
str = args[1]
message(paste("Input structure:", str, "\n"))
## structure name
str_name = unlist(strsplit(str, "\\.", perl = TRUE))[1]
## read structure
str_bio3d = bio3d::read.pdb2(str)

#_______________________________________________________________________________
## input trajectory 
traj = args[2]
message(paste("Input trajectory:", traj, "\n"))
## trajectory name
traj_name = unlist(strsplit(traj, "\\.", perl = TRUE))[1]
## read structure
traj_bio3d = bio3d::read.dcd(traj)

#_______________________________________________________________________________
## xyz indices of Calpha atoms only, gleaned from PDB structure
ca.inds = bio3d::atom.select(str_bio3d, "calpha")

#_______________________________________________________________________________
## encode trajectory
## trajectory is matrix of dimension 3N columns (xyz) and timesteps rows
sa_string.v = encode(traj_bio3d[ , ca.inds$xyz])
## Structural Alphabet sequence in FASTA format
sa_string.fasta = sprintf(">%s%s%s\n%s", str_name, "|", "step", sa_string.v)

## write SA-encoded trajectory as FASTA file
write.table(sa_string.fasta, file = paste(str_name, traj_name, "sasta", sep = '.'),
				quote = FALSE, row.names = FALSE, col.names = FALSE);

#===============================================================================

