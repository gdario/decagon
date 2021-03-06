# Object catalog

This document contains a list of the objects used in the `main.py` function.
 
## Gene-gene interaction network

- `gene_net`: network of gene-gene interactions.
- `gene_adj`: adjacency matrix for the gene-gene interactions.
- `gene_degree`: vector of degrees for the gene network.

## Gene-drug interaction network
- `gene_drug_adj`: adjacency matrix for the gene-drug network.
- `drug_gene_adj`: is the transpose of `gene_drug_adj`.

**NOTE**: decagon is supposed to work also with directed graphs, i.e., we should not always expect the adjacency matrix to be symmetric.
