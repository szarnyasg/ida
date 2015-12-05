#library("SPARQL")
source("SPARQL.R")

evaluate = function(query) {
  sparql.results = SPARQL(
    url = SERVER.URL,
    query = query
  )
  results = sparql.results$results
  return(results)
}

#SERVER.URL = "http://localhost:5820/trainbenchmark/query" # Stardog
SERVER.URL = "http://localhost:8080/sparql" #Corese

#model = "/home/szarnyasg/git/trainbenchmark/models/railway-minimal-routesensor-inferred.ttl"
model = "/home/szarnyasg/git/trainbenchmark/models/railway-repair-1-inferred.ttl"

if (!file.exists(model)) {
  error.message = paste("File does not exist:", model)
  stop(error.message)
}

insert = paste("LOAD <file://", model, "> INTO GRAPH <trainbenchmark>", sep="")
SPARQL(url = SERVER.URL, query = insert)

query.triples  = paste(
  "SELECT ?x ?y ?z",
  "WHERE { ?x ?y ?z }"
)
query.number.of.vertex.types = paste(
  "SELECT (COUNT(DISTINCT ?t) AS ?count)",
  "WHERE { ?_ rdf:type ?t }"
)
query.number.of.edge.types = paste(
  "SELECT (COUNT(DISTINCT ?p) AS ?count)",
  "WHERE { ?_s ?p ?_o }"
)
query.number.of.triples = paste(
  "SELECT (COUNT(DISTINCT *) AS ?count)",
  "WHERE { ?s ?p ?o }"
)
query.number.of.vertices = paste(
  "SELECT (COUNT(DISTINCT ?r) AS ?count)",
  "WHERE { { ?r ?_p1 ?_o1 } UNION { ?_s2 ?_p2 ?r } }"
)

print(evaluate(query.number.of.triples))
print(evaluate(query.number.of.vertex.types))
print(evaluate(query.number.of.vertices))
print(evaluate(query.number.of.edge.types))

