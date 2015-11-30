package hu.bme.mit.metrics.queries;

import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.util.List;

import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVPrinter;
import org.apache.jena.util.FileUtils;
import org.apache.log4j.Logger;

public class QueryMetricsMain {
	
	private static Logger LOGGER = Logger.getLogger("QueryMetricsLogger");
	public final static String EXTENSION = ".sparql";

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
		
		final FileWriter writer = new FileWriter("metrics.csv");
		printCSV(writer, MetricsCalculator.HEADER, calculator.getResults());
	}
	
	public static void printCSV(final Writer writer, final List<String> header, final List<List<Object>> list)
			throws IOException {
		final CSVPrinter printer = new CSVPrinter(writer, CSVFormat.DEFAULT.withRecordSeparator("\n"));
		printer.printRecord(header);

		for (final List<Object> row : list) {
			printer.printRecord(row);
		}
		printer.close();
	}
}
