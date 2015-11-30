package hu.bme.mit.metrics.queries;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;

import org.apache.jena.graph.Node;
import org.apache.jena.sparql.core.TriplePath;
import org.apache.jena.sparql.syntax.ElementFilter;
import org.apache.jena.sparql.syntax.ElementOptional;
import org.apache.jena.sparql.syntax.ElementPathBlock;
import org.apache.jena.sparql.syntax.ElementVisitorBase;
import org.apache.jena.vocabulary.RDF;
import org.apache.log4j.Logger;

// Based on http://stackoverflow.com/questions/15203838/how-to-get-all-of-the-subjects-of-a-jena-query
public class MetricVisitor extends ElementVisitorBase {

	protected Logger logger = Logger.getLogger(this.getClass());
	
	protected final String RDF_TYPE = "http://www.w3.org/1999/02/22-rdf-syntax-ns#type";
	protected final Set<Node> variables = new HashSet<Node>();
	
	protected int numberOfTriples = 0;
	protected int numberOfTypeConstraints = 0;
	protected int numberOfEdgeConstraints = 0;
	protected int numberOfAttributeConstraints = 0;
	protected int numberOfFilterConditions = 0;
	protected int numberOfOptionalConditions = 0;

	@Override
	public void visit(final ElementFilter el) {
		numberOfFilterConditions++;
	}

	@Override
	public void visit(final ElementOptional el) {
		numberOfOptionalConditions++;
	}

	@Override
	public void visit(final ElementPathBlock el) {
		final Iterator<TriplePath> triples = el.patternElts();

		while (triples.hasNext()) {
			final TriplePath triple = triples.next();
			logger.debug(triple);

			// subject-predicate-object
			final Node subject = triple.getSubject();
			final Node predicate = triple.getPredicate();
			final Node object = triple.getObject();

			if (subject.isVariable()) {
				variables.add(subject);
			}
			if (predicate.isVariable()) {
				variables.add(predicate);
			}
			if (object.isVariable()) {
				variables.add(object);
			}

			// check if predicate introduces a type constraint
			if (predicate.isURI()) {
				if (predicate.getURI().equals(RDF.type.getURI())) {
					numberOfTypeConstraints++;
				}

				if (subject.isVariable() && object.isVariable()) {
					numberOfEdgeConstraints++;
				}
			}

			numberOfTriples++;
		}
	}

	// getters
	
	public Set<Node> getVariables() {
		return variables;
	}

	public int getNumberOfTriples() {
		return numberOfTriples;
	}

	public int getNumberOfAttributeConstraints() {
		return numberOfAttributeConstraints;
	}

	public int getNumberOfEdgeConstraints() {
		return numberOfEdgeConstraints;
	}

	public int getNumberOfTypeConstraints() {
		return numberOfTypeConstraints;
	}

	public int getNumberOfFilterConditions() {
		return numberOfFilterConditions;
	}

	public int getNumberOfOptionalConditions() {
		return numberOfOptionalConditions;
	}

}
