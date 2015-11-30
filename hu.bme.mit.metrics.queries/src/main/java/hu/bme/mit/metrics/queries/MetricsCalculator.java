package hu.bme.mit.metrics.queries;

import java.util.List;

import org.apache.jena.query.Query;
import org.apache.jena.query.QueryFactory;
import org.apache.jena.sparql.core.Var;
import org.apache.jena.sparql.syntax.ElementWalker;
import org.apache.log4j.Logger;

public class MetricsCalculator {
	
	protected Logger logger = Logger.getLogger(this.getClass());

	public void analyze(final String queryName, final String queryString) {
		logger.info(
				"----------------------------------------------------------------------------------------------------");
		logger.info(queryName);
		logger.info(
				"----------------------------------------------------------------------------------------------------");

		final Query q = QueryFactory.create(queryString);

		final List<Var> parameterVariables = q.getProjectVars();
		final List<String> resultVariables = q.getResultVars();
		final List<Var> valuesVariables = q.getValuesVariables();

		final MetricVisitor metricVisitor = new MetricVisitor();

		ElementWalker.walk(q.getQueryPattern(), metricVisitor);

		logger.info(String.format("Parameter variables: %d", parameterVariables.size()));
		logger.info(String.format("All variables: %d", metricVisitor.getVariables().size()));
		logger.info(String.format("Number of triples: %d", metricVisitor.getNumberOfTriples()));
		logger.info(String.format("Number of type constraints: %d", metricVisitor.getNumberOfTypeConstraints()));
		logger.info(
				String.format("Number of attribute constraints: %d", metricVisitor.getNumberOfAttributeConstraints()));
		logger.info(String.format("Number of edge constraints: %d", metricVisitor.getNumberOfEdgeConstraints()));
		logger.info(String.format("Number of filter conditions: %d", metricVisitor.getNumberOfFilterConditions()));
		logger.info(String.format("Number of optional conditions: %d", metricVisitor.getNumberOfOptionalConditions()));
		
	}

}
