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
	
	protected int triples = 0;
	protected int typeConstraints = 0;
	protected int edgeConstraints = 0;
	protected int attributeConstraints = 0;
	protected int filterConditions = 0;
	protected int optionalConditions = 0;

	@Override
	public void visit(final ElementFilter el) {
		filterConditions++;
	}

	@Override
	public void visit(final ElementOptional el) {
		optionalConditions++;
	}

	@Override
	public void visit(final ElementPathBlock el) {
		final Iterator<TriplePath> tripleIterator = el.patternElts();

		while (tripleIterator.hasNext()) {
			final TriplePath triple = tripleIterator.next();
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
					typeConstraints++;
				}

				if (subject.isVariable() && object.isVariable()) {
					edgeConstraints++;
				}
			}

			triples++;
		}
	}

	// getters
	
	public Set<Node> getVariables() {
		return variables;
	}

	public int getTriples() {
		return triples;
	}

	public int getAttributeConstraints() {
		return attributeConstraints;
	}

	public int getEdgeConstraints() {
		return edgeConstraints;
	}

	public int getTypeConstraints() {
		return typeConstraints;
	}

	public int getFilterConditions() {
		return filterConditions;
	}

	public int getOptionalConditions() {
		return optionalConditions;
	}

}
