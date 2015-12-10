#library("SPARQL")
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
#SERVER.URL = "http://localhost:8080/sparql" #Corese

### Generic queries

query.triples  = paste(
  "SELECT ?x ?y ?z",
  "WHERE { ?x ?y ?z }"
)
#print(evaluate(query.triples))

### Queries for metamodel metrics

query.vertex.types = paste(
  "SELECT DISTINCT ?x ?t",
  "WHERE { ?x rdf:type ?t }"
)
print(evaluate(query.vertex.types))
source("SPARQL.R")
vt = evaluate(query.vertex.types)


query.vertex.types1 =
  paste(
  "SELECT DISTINCT ?t",
  "WHERE { ?_ rdf:type ?t }"
)
source("SPARQL.R")
vt1 = evaluate(query.vertex.types1)
vt1


query.number.of.vertex.types = paste(
  "SELECT (COUNT(DISTINCT ?t) AS ?count)",
  "WHERE { ?_ rdf:type ?t }"
)
print(evaluate(query.number.of.vertex.types))

query.number.of.edge.types = paste(
  "SELECT (COUNT(DISTINCT ?p) AS ?count)",
  "WHERE { ?_s ?p ?_o }"
)
#print(evaluate(query.number.of.edge.types))

### Queries for instance model metrics

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

delete = "DELETE { ?s ?p ?o } WHERE { ?s ?p ?o }"
SPARQL(url = SERVER.URL, query = delete)

#insert = paste("LOAD <file://", model, "> INTO GRAPH <trainbenchmark>", sep = "")
insert = paste("LOAD <file://", model, ">", sep = "")
SPARQL(url = SERVER.URL, query = insert)


newrow = c(size,
           evaluate.count(query.number.of.triples),
           evaluate.count(query.number.of.vertices))
df[nrow(df)+1, ] = newrow

print(df)
