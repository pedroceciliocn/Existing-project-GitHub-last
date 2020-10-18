#Relationship to base and plyr functions #purrr: split->apply->combine
##why not base?
library(purrr)
install.packages("repurrrsive")
library(tidyverse)

#lapply() vs purrr::map()
##dos exercicios com got e wesanderson
devtools::install_github("MangoTheCat/GoTr")
install.packages("listviewer")

repurrrsive::got_chars %>% 
  str(list.len = 3)

repurrrsive::got_chars %>%
  View()

##base:
library(repurrrsive)
lapply(got_chars[1:3],
       function(x) x[["name"]])

#purrr:
map(got_chars[1:3], "name")


plyr::llply(got_chars[1:3], function(x) x[["name"]]) #tem alguns argumentos como
#.progress e .parallel

#sapply() vs. ¯\_(ツ)_/¯
##sapply() é uma funcao base que tenta de forma razoavel aplicar uma simplificacao para
#a saida do lapply(). ele é pratico para uso interativo, mas por conta da imprevisibilidade
#do valor retornado, nao é aconselhavel usar. nao ha equivalente no purrr ou plyr (pulei).

aliases1 <- sapply(got_chars[20:22], function(x) x[["aliases"]])
str(aliases1)

aliases2 <- sapply(got_chars[c(3, 22, 27)], function(x) x[["aliases"]])
str(aliases2)

map_chr(got_chars[2:4], "aliases")

#vapply() vs map_*()

