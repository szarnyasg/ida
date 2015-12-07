library("reshape2")
library("plyr")
library("ggplot2")

df = read.csv("results-sosym.csv")

times = subset(df, Scenario == "Repair" & Metric == "Time" & (Phase %in% c("Read", "Check")))

times.wide = dcast(times,
                   Scenario + Tool + Run + Case + Artifact + Metric ~ Phase,
                   value.var = "Value")

# calculate aggregated values
times.derived = times.wide
times.derived$Read.and.Check = times.derived$Read + times.derived$Check
times.derived

# summarize for each value (along the **Run** attribute) using the fr function
t = ddply(
  .data = times.derived,
  .variables = c("Scenario", "Tool", "Case", "Artifact", "Metric"),
  .fun = colwise(median)
)



columns <- names(t)
columns <- columns[!columns %in% c("Run", "Read", "Read.and.Check", "Scenario", "Metric")]
t = subset(t, select = columns)
head(t)

tool.times = t[t$Tool == "EMF_API" & t$Artifact == "512", ]
tool.times

query.metrics = read.csv("metrics.csv")
query.metrics = rename(query.metrics, c("query"="Case"))
query.metrics

times.and.metrics = merge(tool.times, query.metrics)
times.and.metrics

cmethod = "kendall"
cor(x = times.and.metrics$parameter.variables, y = times.and.metrics$Check, method = cmethod)
cor(x = times.and.metrics$all.variables, y = times.and.metrics$Check, method = cmethod)
cor(x = times.and.metrics$triples, y = times.and.metrics$Check, method = cmethod)
cor(x = times.and.metrics$type.constraints, y = times.and.metrics$Check, method = cmethod)
cor(x = times.and.metrics$edge.constraints, y = times.and.metrics$Check, method = cmethod)
regression.model <- lm(times.and.metrics$Check ~ times.and.metrics$edge.constraints + times.and.metrics$type.constraints)
summary(regression.model)
ggplot(data = times.and.metrics, aes(x = edge.constraints, y = Check)) +
  geom_point()

