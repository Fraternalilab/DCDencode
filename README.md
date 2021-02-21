## DCDencode: Encode DCD trajectory into Structural Alphabet sequences
[![release](https://img.shields.io/badge/release-v0.1-green?logo=github)](https://github.com/Fraternalilab/DCDencode)

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
Run the script *Rscripts/pdbencode.R* in the directory containing PDB file(s):
```{sh}
Rscript pdbencode.R 
```
The PDB file (with extension ".pdb") and trajectory (".dcd") in that directory
will be processed.
The trajectory yields an encoded \<ID\>_sa.fasta file containing
one SA sequence per chain. The format of SA sequence headers is \<ID\>|\<snapshot\>.

#### Copyright Holders, Authors and Maintainers 
- 2021 Jens Kleinjung (author, maintainer) jens@jkleinj.eu
- 2021 Franca Fraternali (author, maintainer) franca.fraternali@kcl.ac.uk

