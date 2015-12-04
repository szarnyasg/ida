package hu.bme.mit.metrics.model;


import fr.inria.acacia.corese.exceptions.EngineException;
import fr.inria.edelweiss.kgram.core.Mappings;
import fr.inria.edelweiss.kgraph.core.Graph;
import fr.inria.edelweiss.kgraph.query.QueryProcess;
import fr.inria.edelweiss.kgtool.load.Load;

public class CoreseMain {
	public static void main(final String[] args) throws EngineException {
		final Graph graph = Graph.create();
		
		final Load ld = Load.create(graph);
		ld.load("/home/szarnyasg/git/trainbenchmark/models/railway-minimal-routesensor-inferred.ttl");
		
		final QueryProcess exec = QueryProcess.create(graph);
		final String query = "select * where {?x ?p ?y}";
		evaluate(exec, query);		
	}

	private static void evaluate(final QueryProcess exec, final String query) throws EngineException {
		final Mappings map = exec.query(query);		
		System.out.println(map);
	}
}
