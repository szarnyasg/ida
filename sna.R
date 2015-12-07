### Social network analysis

sna.number.of.actors = paste(
  "PREFIX base: <http://www.semanticweb.org/ontologies/2015/trainbenchmark#>",
  "select merge",
  "(count(?x) as ?nbactor)",
  "where {",
  "  ?x rdf:type base:Route",
  "}"
)
print(evaluate(sna.number.of.actors))

sna.diameter = paste(
  "PREFIX base: <http://www.semanticweb.org/ontologies/2015/trainbenchmark#>",
  "select pathLength($path) as ?length",
  "where {",
  "  ?y s (base:follows)*::$path ?to",
  "}",
  "order by desc(?length) limit 1"
)
print(evaluate(sna.diameter))

sna.component = paste(
  "PREFIX base: <http://www.semanticweb.org/ontologies/2015/trainbenchmark#>",
  "select ?x ?y",
  "where {",
  "  ?x base:follows ?y",
  "}",
  "group by any"
)
print(evaluate(sna.component))

