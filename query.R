#library("SPARQL")

#SERVER.URL = "http://localhost:5820/trainbenchmark/query"
SERVER.URL = "http://localhost:8080/sparql"

insert = 'PREFIX foaf: <http://xmlns.com/foaf/0.1/> INSERT DATA { <http://edf.org/resource/dev> foaf:name "dev" . }'
print(insert)

sparql.results = SPARQL(
  url = SERVER.URL,
  query = insert
)

#query = "SELECT (COUNT(*) AS ?count) WHERE { ?x ?y ?z }"
#sparql.results = SPARQL(url = SERVER.URL, query = query)
#sparql.results

evaluate = function(query) {
  sparql.results = SPARQL(
    url = SERVER.URL,
    query = query
  )
  results = sparql.results$results
  results
}

count.hello.world = paste(
  "SELECT (COUNT(*) as ?count)",
  "WHERE { ?x ?y ?z }"
)
hello.world = paste(
  "SELECT ?x ?y ?z",
  "WHERE { ?x ?y ?z }"
)
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

evaluate(count.hello.world)

source("SPARQL.R")
evaluate(hello.world)
print(evaluate(count.hello.world))
#evaluate(query.number.of.types)
#evaluate(query.number.of.triples)
#evaluate(query.number.of.vertices)
#evaluate(query.number.of.edges)
