#===============================================================================
# DCDencode 
# dcdencode.R
# Read PDB structure and trajectory in local directory
# Encode trajectory and write SA strings as FASTA format
#===============================================================================

library("DCDencode")
library("bio3d")
library("pbapply")

#_______________________________________________________________________________
## by default no conformation increment (first conformation is '1 + confInc')
confInc = 0

## command line arguments
args = commandArgs(trailingOnly = TRUE)
## argument [1] is input structure
str = as.character(args[1])
## argument [2] is input trajectory
traj = as.character(args[2]) 
## argument [3] is conformation increment if trajectory has been split
confInc = abs(as.integer(args[3]))

error = tryCatch(stopifnot(nchar(args[1]) < 1, nchar(args[2]) < 1),
  error = function(e) {
    ## stopifnot error message
    message(e)
    ## usage message
    message("\nUsage: 'Rscript dcdsplit.R <str> <traj> <confInc>'")
    ## exit TryCatch with error code
    return(1)
  }
)
## stop if error code exists
if (! is.null(error)) { stop("Caught error in input arguments") }

#_______________________________________________________________________________
## args[1]: input structure
#args[1] = "/mnt/databases/MD/PKM2/3BJT_monomer_apo/md0/3BJT_md0_ca.pdb"
message("  The atom order and number of the input structure and input trajectory must match.\
Please note that potential mis-matches are unlikely to be detected by DCDencode.")
message(paste("Input structure:", str))
## structure name
str_name = unlist(strsplit(str, "\\.", perl = TRUE))[1]
## read structure
str_bio3d = bio3d::read.pdb2(str)

#_______________________________________________________________________________
## args[2] is input trajectory
#args[2] = "/mnt/databases/MD/PKM2/3BJT_monomer_apo/md0/3BJT_md0_ca.dcd"
message(paste("Input trajectory:", traj))
## trajectory name
traj_name = unlist(strsplit(traj, "\\.", perl = TRUE))[1]
## read structure
traj_bio3d = bio3d::read.dcd(traj)

#_______________________________________________________________________________
## args[3] is conformation increment if trajectory has been split
## the increment is added to the conformation number
message(paste("Output SA string numbering will start at #", confInc + 1))

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

