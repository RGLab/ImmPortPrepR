# For comparing old and new template versions

new <- "data-raw/templates.json"
old <- "data-raw/templates.json.2019"

new <- rjson::fromJSON(file = new)
old <- rjson::fromJSON(file = old)

# difference in tables?
names(new) <- sapply(new, function(x) {
  return(x$name)
})
names(old) <- sapply(old, function(x) {
  return(x$name)
})

# check names first
all.equal(names(new), names(old))

# for each name, check that colnames are same and if not
# then store is results list for reference
res <- list()
for (nm in names(new)) {
  tmp <- all.equal(new[[nm]]$columns, old[[nm]]$columns)
  if (!isTRUE(tmp)) {
    res[[nm]] <- tmp
  }
}
