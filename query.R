#library("SPARQL")
library("ggplot2")
source("SPARQL.R")

evaluate = function(query) {
  sparql.results = SPARQL(
    url = SERVER.URL,
    query = query
  )
  result = sparql.results$results
  return(result)
}

evaluate.count = function(query) {
  result = evaluate(query)
  result$count
}

SERVER.URL = "http://localhost:5820/ida/query" # Stardog
#SERVER.URL = "http://localhost:8080/sparql" # Corese

##############################################################################
### Generic queries
##############################################################################

query.triples  = paste(
  "SELECT ?x ?y ?z",
  "WHERE { ?x ?y ?z }"
)
#print(evaluate(query.triples))

##############################################################################
### Queries for metamodel metrics
##############################################################################

#### Vertex types

query.vertex.types = paste(
  "SELECT DISTINCT ?t",
  "WHERE { ?_ rdf:type ?t }"
)
vertex.types = evaluate(query.vertex.types)
#print(vertex.types)

query.number.of.vertex.types = paste(
  "SELECT (COUNT(DISTINCT ?t) AS ?count)",
  "WHERE { ?_ rdf:type ?t }"
)
#print(evaluate(query.number.of.vertex.types))

#### Edge type

query.edge.types = paste(
  "SELECT DISTINCT ?p",
  "WHERE { ?_s ?p ?_o }"
)
edge.types = evaluate(query.edge.types)
#print(edge.types)

query.number.of.edge.types = paste(
  "SELECT (COUNT(DISTINCT ?p) AS ?count)",
  "WHERE { ?_s ?p ?_o }"
)
#print(evaluate(query.number.of.edge.types))

##############################################################################
### Queries for instance model metrics
##############################################################################

query.number.of.triples = paste(
  "SELECT (COUNT(DISTINCT *) AS ?count)",
  "WHERE { ?s ?p ?o }"
)
#print(evaluate(query.number.of.triples))

query.number.of.vertices = paste(
  "SELECT (COUNT(DISTINCT ?r) AS ?count)",
  "WHERE { { ?r ?_p1 ?_o1 } UNION { ?_s2 ?_p2 ?r } }"
)
print(evaluate(query.number.of.vertices))

#"query.number.of.vertex.types",
#"query.number.of.edge.types",

#evaluate.count(query.number.of.vertex.types),
#evaluate.count(query.number.of.edge.types),

attrs = c("size",
          "query.number.of.triples",
          "query.number.of.vertices")
df = data.frame(matrix(ncol = length(attrs), nrow = 0))
colnames(df) = attrs

#for (size in 2^(0:0)) {
size = 1
model = paste("/home/szarnyasg/git/trainbenchmark/models/railway-batch-", size, "-inferred.ttl", sep='')
  
if (!file.exists(model)) {
  error.message = paste("File does not exist:", model)
  stop(error.message)
}

reload = function() {
  delete = "DELETE { ?s ?p ?o } WHERE { ?s ?p ?o }"
  SPARQL(url = SERVER.URL, query = delete)
  
  #insert = paste("LOAD <file://", model, "> INTO GRAPH <trainbenchmark>", sep = "")
  insert = paste("LOAD <file://", model, ">", sep = "")
  SPARQL(url = SERVER.URL, query = insert)
}



width = 200
height = 100

# skip rdf:type
#for(i in 2:nrow(edge.types)) {
for(i in 5:5) {
  edge.type = edge.types[i,]
  print(edge.type)

  query.indegree = paste(
    "SELECT (COUNT(?s) AS ?indegree)",
    "WHERE {",
    "  ?s", edge.type, "?o",
    "}",
    "GROUP BY ?o"
  )
  print(query.indegree)
  indegree = evaluate(query.indegree)
  
  plot.indegree = ggplot(data = indegree, aes(indegree)) +
    geom_histogram(binwidth = 1) +
    ggtitle(edge.type)
  print(plot.indegree)
  ggsave(file = paste("diagrams/plot-", i, "-indegree", ".pdf", sep = ""), width = width, height = height, units = "mm")
  
  ######################################################################
  
#  query.outdegree = paste(
#    "SELECT (COUNT(?o) AS ?outdegree)",
#    "WHERE {",
#    "  ?s", edge.type, "?o",
#    "}",
#    "GROUP BY ?s"
#  )
#  print(query.outdegree)
#  outdegree = evaluate(query.outdegree)
  
#  plot.outdegree = ggplot(data = outdegree, aes(outdegree)) +
#    geom_histogram(binwidth = 8) +
#    ggtitle(edge.type)
#  print(plot.outdegree)
#  ggsave(file = paste("diagrams/plot-", i, "-outdegree", ".pdf", sep = ""), width = width, height = height, units = "mm")
}


plot.indegree = ggplot(data = indegree, aes(indegree)) +
  geom_histogram(binwidth = 8) +
  ggtitle(edge.type)
print(plot.indegree)
ggsave(file = paste("diagrams/plot-", i, "-indegree", ".pdf", sep = ""), width = width, height = height, units = "mm")


plot.outdegree = ggplot(data = outdegree, aes(outdegree)) +
  geom_histogram(binwidth = 5) +
  ggtitle(edge.type)
print(plot.outdegree)
ggsave(file = paste("diagrams/plot-", i, "-outdegree", ".pdf", sep = ""), width = width, height = height, units = "mm")
