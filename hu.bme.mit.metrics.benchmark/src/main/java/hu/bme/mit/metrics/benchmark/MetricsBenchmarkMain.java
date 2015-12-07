package hu.bme.mit.metrics.benchmark;

import java.io.File;
import java.io.IOException;
import java.util.concurrent.TimeUnit;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.openrdf.query.BindingSet;
import org.openrdf.query.MalformedQueryException;
import org.openrdf.query.QueryEvaluationException;
import org.openrdf.query.QueryLanguage;
import org.openrdf.query.TupleQuery;
import org.openrdf.query.TupleQueryResult;
import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryConnection;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.sail.SailRepository;
import org.openrdf.rio.RDFFormat;
import org.openrdf.rio.RDFParseException;
import org.openrdf.sail.memory.MemoryStore;

import com.google.common.base.Stopwatch;

public class MetricsBenchmarkMain {

	private static Logger LOGGER = Logger.getLogger("QueryMetricsLogger");

	public static void main(final String[] args) throws IOException, RepositoryException, RDFParseException,
			MalformedQueryException, QueryEvaluationException {
		if (args.length < 3) {
			LOGGER.error("Usage: java -jar <model> <param1> <param2>");
			return;
		}

		final String modelPath = args[0];
		final String param1 = args[1];
		final String param2 = args[2];

		final File modelFile = new File(modelPath);

		final String query = String.format("Chain-%s-%s", param1, param2);
		final String queryFile = "../synthetic-queries/" + query + ".sparql";
		// System.out.println(queryFile);

		final String queryDefinition = FileUtils.readFileToString(new File(queryFile));
		// System.out.println(queryDefinition);

		final Repository repository = new SailRepository(new MemoryStore());
		repository.initialize();
		final RepositoryConnection connection = repository.getConnection();
		connection.add(modelFile, RDFConstants.BASE_PREFIX, RDFFormat.TURTLE);

		
		final Stopwatch stopwatch = Stopwatch.createStarted();
		final TupleQuery tupleQuery = connection.prepareTupleQuery(QueryLanguage.SPARQL, queryDefinition);
		final TupleQueryResult queryResults = tupleQuery.evaluate();
		while (queryResults.hasNext()) {
			final BindingSet bs = queryResults.next();
		}
		stopwatch.stop();

		//"Scenario", "Tool", "Run", "Case", "Artifact", "Phase", "Iteration", "Metric", "Value"

		final long checkTime = stopwatch.elapsed(TimeUnit.NANOSECONDS);
		
		final StringBuilder builder = new StringBuilder();
		builder.append("Batch,");
		builder.append("Sesame,");
		builder.append("0,");
		builder.append(query + ",");
		builder.append("512,");
		builder.append("Check,");
		builder.append("0,");
		builder.append("Time,");
		builder.append(checkTime);
		
		System.out.println(builder.toString());
	}

}
