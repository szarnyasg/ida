Corese web server:

```
java -jar corese-server-3.1.8.jar
```


Insert a single triple:

```
insert = 'PREFIX foaf: <http://xmlns.com/foaf/0.1/> INSERT DATA { <http://edf.org/resource/dev> foaf:name "dev" . }'
```

Query the number of all triples:

```
SELECT (COUNT(DISTINCT *) AS ?count)
WHERE { ?s ?p ?o }
```
