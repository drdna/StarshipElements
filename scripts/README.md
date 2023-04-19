# Scripts for Starship Analyses

## 1. Break multifasta files into individual sequences
Simply point the [fasta-break.pl](/scripts/fasta-break.pl) script to the multifasta file needing to be split and provide the name of the directory into which the single fastas should be deposited.

```bash
perl fasta-break.pl MultiFasta.fasta SingleFastaDirectoryName
```

## 2. PERL modules used in various scripts.

a. Install module in PERL search path, or add location to path:
```bash
export PERL5LIB=$PERL5LIB:path/to/module-folder
```
b. Make module executable:
```bash
chmod a+x path/to/module-folder/moduleName.pm
```
c. Run code that uses module.
