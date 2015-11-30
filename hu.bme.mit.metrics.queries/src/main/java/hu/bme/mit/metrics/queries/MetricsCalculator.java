package hu.bme.mit.metrics.queries;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.jena.query.Query;
import org.apache.jena.query.QueryFactory;
import org.apache.jena.sparql.core.Var;
import org.apache.jena.sparql.syntax.ElementWalker;
import org.apache.log4j.Logger;

public class MetricsCalculator {

	protected Logger logger = Logger.getLogger(this.getClass());

	public static final List<String> HEADER = Arrays.asList("query", "all.variables", "parameter.variables", "triples", "type.constraints",
			"attribute.constraints", "edge.constraints", "filter.conditions", "optional.conditions");
	protected final List<List<Object>> results = new ArrayList<List<Object>>();
	
	public void analyze(final String queryName, final String queryString) throws IOException {
		final List<Object> row = new ArrayList<>();
		row.add(queryName);
		
		logger.info(
				"----------------------------------------------------------------------------------------------------");
		logger.info(queryName);
		logger.info(
				"----------------------------------------------------------------------------------------------------");

		final Query q = QueryFactory.create(queryString);
		final List<Var> parameterVariables = q.getProjectVars();

		final MetricVisitor metricVisitor = new MetricVisitor();	
		ElementWalker.walk(q.getQueryPattern(), metricVisitor);
		
		row.add(metricVisitor.getVariables().size());
		logger.info(String.format("All variables: %d", metricVisitor.getVariables().size()));
		row.add(parameterVariables.size());
		logger.info(String.format("Parameter variables: %d", parameterVariables.size()));

		row.add(metricVisitor.getTriples());
		logger.info(String.format("Number of triples: %d", metricVisitor.getTriples()));
		row.add(metricVisitor.getTypeConstraints());
		logger.info(String.format("Number of type constraints: %d", metricVisitor.getTypeConstraints()));
		row.add(metricVisitor.getAttributeConstraints());
		logger.info(String.format("Number of attribute constraints: %d", metricVisitor.getAttributeConstraints()));
		row.add(metricVisitor.getEdgeConstraints());
		logger.info(String.format("Number of edge constraints: %d", metricVisitor.getEdgeConstraints()));
		row.add(metricVisitor.getFilterConditions());
		logger.info(String.format("Number of filter conditions: %d", metricVisitor.getFilterConditions()));
		row.add(metricVisitor.getOptionalConditions());
		logger.info(String.format("Number of optional conditions: %d", metricVisitor.getOptionalConditions()));
		
		results.add(row);
	}
	
	public List<List<Object>> getResults() {
		return results;
	}

}
