fail <- function() {
    Sys.sleep(5);
    throw("Something broke")
    return(TRUE);
}

cat(fail());