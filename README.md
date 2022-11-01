# MarRef_DeepMicrobes
Retraining of DeepMicrobes using the MarRef dataset
## 1) Shell Scripts
- Bowtie: using bowtie to map reads back to reference genomes
- Camisim: generation of the 10 blind datasets
- convert_to_tfrec: convert the test, and training datasets to a tfrec format
- download_bioproject: download SRRs for analysis
- predict_species: run prediction on either test or blind dataset
- genus_training_example: example for training 1 epoch of genus
- species_training_example: example for training 1 epoch of species

## 2) Jupyter Notebooks
- ROC_Curve: generate ROC curve, Precision, Recall, TPR, FPR for the test datasets.
- Blind_set_analysis: generate abundance graph, graphs for accuracy as a function of reference genome coverage, and other graphs that are not in the final manuscript

## 3) Datafiles
- p-r: used for abundance graph
- length_number_species: GC, length, % coverage, and # genomes / genus for microbes in MarRef
- MarRef_taxonomy: species, genus, family (etc) and ID, species and genus code used in training
- MarRef_metadata: all metadata downloaded from MarRef project
