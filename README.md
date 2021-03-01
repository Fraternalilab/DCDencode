## DCDencode: Encode DCD trajectory into Structural Alphabet sequences
[![release](https://img.shields.io/badge/release-v0.4-green?logo=github)](https://github.com/Fraternalilab/DCDencode)

The package provides the functionality to encode a given trajectory
into Structural Alphabet (SA) strings.


## Installation
There are several ways to install the *DCDencode* package, please choose one of the following.
You need to have R installed and the *bio3d* package.

### Linux shell
Download the [latest *DCDencode* release (.tar.gz)](https://github.com/Fraternalilab/DCDencode/releases/latest)
and install on the shell with (example for version 0.1):
```{sh}
R CMD INSTALL DCDencode-v.0.1.tar.gz
```

### R console
Download the [latest *DCDencode* release (.tar.gz)](https://github.com/Fraternalilab/DCDencode/releases/latest) and
install from the R console (example for version 0.1, assuming it is located in the current directory):
```{r}
install.packages("./DCDencode-v.0.1.tar.gz")
```

### R console with devtools
Install the *devtools* package and install *DCDencode* directly from GitHub:
```{r}
library("devtools")
install_github("Fraternalilab/DCDencode")
```


## Usage
### Encoding
Run the script *Rscripts/dcdencode.R* in the directory containing the DCD trajectory file:
```{sh}
Rscript pdbencode.R <structure_name>.pdb <trajectory_name>.dcd <confInc>
```
The first argument must be the reference PDB structure.
The second argument must be the DCD trajectory.
The third argument <confInc> is an optional conformation increment (integer)
that will be added to the number of the first conformation, which is always '1'.
The specified DCD trajectory will be encoded into a
'<structure\_name>.<trajectory\_name>.sasta' file
containing one SA sequence per trajectory conformation in FASTA-type format.
The format of SA sequence headers is \<ID\>|\<conformation\>,
where ID is a dot-separated structure and trajectory name,
while conformations are numbered from 1 to N (= total number of conformations),
plus the conformation increment (default = 0).

### Splitting DCD trajectories
Trajectories can be large and therefore the encoding routine can be memory hungry.
To avoid running out of RAM, a script employing the *catdcd* program (VMD suite)
is included, which facilitates splitting the trajectory into blocks:
```{sh}
Rscript dcdsplit.R <traj_name>.dcd <first> <last> <nConf>
```
After encoding all blocks, the resulting SA strings can be concatenated to the complete encoded trajectory.


#### Copyright Holders, Authors and Maintainers 
- 2021 Jens Kleinjung (author, maintainer) jens@jkleinj.eu
- 2021 Franca Fraternali (author, maintainer) franca.fraternali@kcl.ac.uk

