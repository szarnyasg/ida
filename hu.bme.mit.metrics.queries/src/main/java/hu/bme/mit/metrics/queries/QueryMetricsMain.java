package hu.bme.mit.metrics.queries;

import java.io.IOException;

import org.apache.jena.util.FileUtils;
import org.apache.log4j.Logger;

public class QueryMetricsMain {
	
	private static Logger LOGGER = Logger.getLogger("QueryMetricsLogger");
	
	final static String EXTENSION = ".sparql";

	public static void main(final String[] args) throws IOException {
		if (args.length < 1) {
			LOGGER.error("Usage: java -jar <jarfile.jar> <path-to-sparql-queries>");
			return;
		}
		
		final String path = args[0];		
		final MetricsCalculator calculator = new MetricsCalculator();		
		for (final TrainBenchmarkQuery queryName : TrainBenchmarkQuery.values()) {
			final String fileName = path + "/" + queryName + EXTENSION;
			final String queryString = FileUtils.readWholeFileAsUTF8(fileName);
			calculator.analyze(queryName.toString(), queryString);
		}
	}
}
