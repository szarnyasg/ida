library("SPARQL")

SERVER.URL = "http://localhost:5820/trainbenchmark/query"

evaluate = function(query) {
  sparql.results = SPARQL(
    url = SERVER.URL,
    query = query
  )
  results = sparql.results$results
  print(results)
}

query.number.of.types = paste(
  "SELECT (COUNT(DISTINCT ?t) AS ?count)",
  "WHERE { ?_ rdf:type ?t }"
)
query.number.of.triples = paste(
  "SELECT (COUNT(DISTINCT *) AS ?count)",
  "WHERE { ?s ?p ?o }"
)
query.number.of.vertices = paste(
  "SELECT (COUNT(DISTINCT ?s) AS ?count)",
  "WHERE { { ?s ?_p ?_o } UNION { ?_o ?_p ?s } }"
)
query.number.of.edges = paste(
  "SELECT (COUNT(DISTINCT ?p) AS ?count)",
  "WHERE { ?_s ?p ?_o }"
)

evaluate(query.number.of.types)
evaluate(query.number.of.triples)
evaluate(query.number.of.vertices)
evaluate(query.number.of.edges)

