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

## Drug-drug interaction network

- `drug_drug_adj_list`: list of adjacency matrices. One for each side-effect.
- `drug_degrees_list`: list of drug-level degrees. One for each side-effect.

## Data representation

### `adj_mats_orig`

This dictionary contains the adjacency matrices described above. The keys are tuples of the form `(i, j)`, where $i, j \in {0, 1}$. A 0 represent a gene node. A 1 represents a drug node. Note that (0, 1) and (1, 0) are different when the graph is directed. When the key is of the form `(i, i)`, i.e., the two nodes are of the same type, the corresponding value is a list containing the adjacency matrix and its transpose.

### `degrees`

Dictionary containing the degrees of the gene and drug adjacency matrices. The keys are either 0 or 1, indicating a gene node or a drug node. The values are lists containing the degrees of the adjacency matrix and of its transpose.

## Features

**TODO** clarify this part. The notes below represent my current understanding, and should be taken with care.

This is one of the most confusing parts of the code. For genes and drugs we compute three quantities:

- `X_nonzero_feat`: number of features that contain at least one non-zero entry across genes?
- `X_num_feat`: total number of features.
- `X_feat`. This is the output of `preprocessing.sparse_to_tuple()`, see below.

### `preprocessing.sparse_to_tuple()`

This function takes a sparse matrix and returns three things:

1. Coordinates: the indices of the non-zero entries in the matrix.
2. Values: the values of the non-zero elements.
3. Shape: the shape of the original sparse matrix.

#### Example

```{py}
x = np.array([[0, 0, 1], [0, 1, 0], [0, 1, 1], [0, 1, 2]])
sx = sp.csr_matrix(x)
preprocessing.sparse_to_tuple(sx)
```

To run the code above you need to import `preprocessing` and `numpy`
The code above returns the following:

```
(array([[0, 2],
       [1, 1],
       [2, 1],
       [2, 2],
       [3, 1],
       [3, 2]], dtype=int32), array([1, 1, 1, 1, 1, 2]), (4, 3))
```

## Feature representation

The dictionaries below contain the information about node-level features.

- `num_feat`: dictionary with keys 0 and 1, and values `gene_num_feat` and `drug_num_feat` respectively.
- `nonzero_feat`: dictionary with keys 0 and 1 and values `gene_nonzero_feat` and `drug_nonzero_feat` respectively.
- `feat`: dictionary with keys 0 and 1 and values `gene_feat` and `drug_feat` respectively. These are the tuples containing coordinates, values and shape.
- `edge_type2dim`: dictionary with the same keys as `adj_mats_orig`. The values are lists containing the shapes of all the matrices contained in each value of `adj_mats_orig`.
- `edge_types`: dictionary with the same keys as `adj_mats_orig` containing, for each key, the length of the corresponding value. See below.
- `num_edge_types`: sum of the values of `edge_types`.

### `edge_types`

The `edge_types` dictionary contains the keys `(0, 0)`, `(0, 1)`, `(1, 0)`, `(1, 1)`. The value associated with each key is the length of the list associated with the same key in `mat_adj_orig`. This list contains the adjacency matrix for that key-pair type and, if the key pair contains nodes of the same type, i.e., is in the form `(i, i)`, also for the transpose. If we have 3 edge types, as in the toy example that ships with `main.py`, the dictionary looks as follows:


```py
{
    (0, 0): 2,  # 1 type of relation for gene-gene nodes + transpose.
    (0, 1): 1,  # 1 type of relation for gene-drug pairs.
    (1, 0): 1,  # 1 type of relation for drug-gene pairs.
    (1, 1): 6   # 3 types of relation for drug-drug nodes + transposes.
}
```

## Placeholders

The `construct_placeholders()` function takes `edge_types` defined above and builds a dictionary of placeholders, and precisely (NOTE: ??? means I don't yet know what the placeholder is supposed to store):

- `batch`: integer placeholder for the bach count.
- `batch_edge_type_idx`: integer placeholder for the index of the edge type.???
- `batch_row_edge_type`: integer placeholder for the edge type. ???
- `batch_col_edge_type`: ???
- `degrees`: integer placeholder for the degrees.
- `dropout`: placeholder with default (0 = no dropout).
- `adj_mats_i,j,k`: sparse placeholder for the adjacency matrix associated with relation `k` in pair `(i, j)`.

## Iterators

### Edge Minibatch Iterator

#### Methods of the `EdgeMinibatchIterator` class

- `__init__()`
- `preprocess_graph()`
- `_ismember()`
- `mask_test_edges()`
- `end()`
- `update_feed_dict()`
- `batch_feed_dict()`
- `next_minibatch_feed_dict()`
- `num_training_batches()`
- `val_feed_dict()`
- `shuffle()`