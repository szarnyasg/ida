query.vertex.types = paste(
  "SELECT DISTINCT ?t",
  "WHERE { ?_ rdf:type ?t }"
)
source("SPARQL.R")
vt1 = evaluate(query.vertex.types)
print(vt1)

query.vertex.types2 =
  paste(
  "SELECT DISTINCT ?x ?t",
  "WHERE { ?x rdf:type ?t }"
)
source("SPARQL.R")
vt2 = evaluate(query.vertex.types2)
print(vt2)

