#WRANGLING
#tibbles
library(tidyverse)
as_tibble(iris)

tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y
)


tb <- tibble(
  `:)` = "smile",
  ` ` = "space",
  `2000` = "number"
)
tb

#alternativa ao tibble comum
tribble(
  ~x, ~y, ~z,
  #--/--/---- #pra deixar claro onde esta o header
  "a", 2, 3.6,
  "b", 1, 8.5
)

#o tibble mostra apenas as 10 primeiras linhas e todas as colunas que cabem na tela e alem de seu nome, cada coluna diz o seu tipo 
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

nycflights13::flights %>% 
  print(n = 10, width = Inf) #n é o numero de linhas e com width = Inf, exibe todas as colunas



nycflights13::flights %>% 
  print(options(tibble.print_max = n, tibble.print_min = m)) #se mais de m linhas imprimir apenas n linhas

nycflights13::flights %>% 
  print(options(dplyr.print_min = Inf)) #sempre mostra todas as linhas

nycflights13::flights %>% 
  print(options(tibble.width = Inf)) #imprime todas as colunas independente da largura da tela

#visualizador interno do rstudio
nycflights13::flights %>% 
  View()


#subconjuntos
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
df

#extrair pelo nome
df$x

df[["x"]]

#extrair pela posicao (numero da linha)
df[[1]]

#pra usa-los em um pipe precisa usar o marcador de posicao especial .
df %>% .$x
df %>% .[["x"]]

#algumas funcoes antigas nao funfam com tibble. Deve-se usar as.data.frame() para transformar um tibble de volta em um data.frame
class(as.data.frame(tb))


#exercicios
#1.
mtcars
is_tibble(mtcars) #pra checar se e tibble
is_tibble(ggplot2::diamonds)
is_tibble(nycflights13::flights)
is_tibble(as_tibble(mtcars))

class(mtcars) #mostra a classe que nao e tibble
class(ggplot2::diamonds)
class(nycflights13::flights)

tibble(mtcars) 
as_tibble(mtcars)#o tibble mostra os tipos

#2. 
df <- data.frame(abc = 1, xyz = "a")
df$x #o operador $ vai combinar com qualquer coluna que comece com x (é um comportamento desse operador)
df$xy
df$xyz
df$abc

df[, "xyz"]
df[, c("abc", "xyz")]

tbl <- as_tibble(df)
tbl$x
tbl$xyz
tbl$a
tbl$abc

tbl[, "xyz"]
tbl[, "abc"]
tbl[, c("abc", "xyz")]

tbl[1,]
tbl["a", ]
tbl["1", "abc"]
tbl["a", "xyz"]


# O [[]] extrai por nome e posicao, o $ so por nome
#3.
var <- "mpg"
df$xyz
df[["xyz"]]


#4.
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)

#a. extrair a variavel chamada 1
annoying["1"] #retorna um tibble #ou annoying[1] #apenas a coluna 1

#ou
annoying[[1]] #retorna um vetor

#ou
annoying[["1"]] #retorna um vetor

#ou
annoying$`1` #retorna um vetor

#b. plotar um diagrama de dispersao de 1 versus 2
ggplot(annoying, aes(x = `1`, y = `2`)) +
  geom_point()

#c. criar uma nova coluna chamada 3, que é 2 dividido por 1
annoying$`3` <- annoying$`2`/annoying$`1`
annoying
#ou
annoying[[3]] <- annoying[[2]]/annoying[[1]]
annoying
#ou
mutate(annoying, `3` = `2`/`1`)
#ou
annoying[["3"]] <- annoying[["2"]]/annoying[["1"]]
annoying

#d. renomear as colunas para one, two e three
annoying <- rename(annoying, one = `1`, two = `2`, three = `3`)
glimpse(annoying)


#5. oq tibble::enframe() faz?
##converte named vectors em um data.frame com nomes e valores

enframe(c(a = 1, b = 2, c = 3))

#6. qual opcao controla quantos nomes de colunas adicionais sao impressos no rodape de um tibble?
?print.tbl
#o argumento n_extra determina o numero extra de colunas
