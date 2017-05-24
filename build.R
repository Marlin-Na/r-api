
library(yaml)

addyaml <- function (path, content) {
    tmpfile <- tempfile()
    orifile <- path
    yamlheader <- c("---", yaml::as.yaml(content) ,"---", "")
    write(yamlheader, tmpfile, append = TRUE)
    write(readLines(orifile), tmpfile, append = TRUE)
    write("", tmpfile, append = TRUE)
    
    file.remove(orifile)
    file.copy(tmpfile, orifile)
    return(TRUE)
}

sublinks <- function (path) {
    system2("sed",
        c("-i", shQuote("s/\\](\\([A-Za-z-]*\\.md\\))/]({{< relref \"\\1\" >}})/g"), path)
    )
    system2("sed",
        c("-i", shQuote("s/\\](\\(diagrams\\/[A-Za-z-]*\\.png\\))/](\\/r-api\\/\\1)/g"), path)
    )
}


tmpdir <- tempfile(pattern = "dir")
dir.create(tmpdir)
file.copy("source/", tmpdir, recursive = TRUE)
file.rename(file.path(tmpdir, "source"), file.path(tmpdir, "content"))
tmpdir <- file.path(tmpdir, "content")

file.remove(file.path(tmpdir, "r-internals.Rproj"))

mdfiles     <- list.files(tmpdir, pattern = ".*md", full.names = TRUE)
indexfile   <- mdfiles[basename(mdfiles) == "README.md"]
commonfiles <- mdfiles[basename(mdfiles) != "README.md"]

addyaml(indexfile, list(menu = "main", type = "homepage", title = "Index"))
sublinks(indexfile)

for (i in commonfiles) {
    addyaml(i, list(menu = "main", title = basename(i)))
    sublinks(i)
}

file.copy(tmpdir, ".", recursive = TRUE)
file.copy(file.path(tmpdir, "diagrams"), "static", recursive = TRUE)

cat("Done!", "\n")
