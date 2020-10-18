(v_log <- c(TRUE, FALSE, FALSE, TRUE))
(v_int <- 1:4)
(v_doub <- 1:4 * 1.2) 
(v_char <- letters[1:4])

#exercicios
#1. 
is.integer(v_int)

rlang::is_bool(v_log)

v_char[c(FALSE, FALSE, TRUE, TRUE)] #mostrou os elementos com o true
v_char[v_log] #mostrou somente os elementos com o true do v_log

v_doub[2:3] #mostrou o segundo e o terceiro elementos
v_char[-4] #tirou o ultimo elemento do vetor

#exercicio
#1. oq acontece quando voce pede por um elemento na posicao 0?
v_char[0]
v_doub[0]
v_int[0]
typeof(v_int[0])
v_log[0]
v_log[100]
typeof(v_log[100])

#2.
v_char[4]
v_log[4]
v_int[5]
v_doub[5]

v_char[c(FALSE, FALSE, TRUE)]

#coercion
v_log
as.integer(v_log) #transforma os TRUE e FALSE em 1 e 0

v_int
as.numeric(v_int)

v_doub
as.character(v_doub)
as.character(as.numeric(as.integer(v_log))) #transformou em 1 e 0 e em char
typeof(as.character(as.numeric(as.integer(v_log))))

v_doub_copy <- v_doub
str(v_doub_copy)
v_doub_copy[3] <- "uhoh"
str(v_doub_copy)

(big_plans <- rep(NA_integer_, 4))
str(big_plans)
big_plans[3] <- 5L 
str(big_plans)
big_plans[1] <- 10 #sem o L resulta numa coercao de bigplans para double
str(big_plans)

#Exercicio
#1. 
as.integer(letters)
as.numeric(letters)
as.logical(letters)
as.character(big_plans)
as.logical(big_plans)
as.integer(big_plans)

#lists
(x <- list(1:3, c("four", "five")))

(y <- list(logical = TRUE, integer = 4L, double = 4*1.2, character = "character"))

(z <- list(letters[26:22], transcendental = c(pi, exp(1)), f = function(x) x^2))

is.logical(z)

#list indexing
##com uma chave simples (sempre retorna uma lista)
x[c(FALSE, TRUE)] #nao exibe o primeiro elemento da lista (FALSE), somente o segundo (TRUE)

y[2:3] #so exibe o segundo e terceiro elementos

z["transcendental"] #so exibe o elemento chamado transcendental

##com duas chaves (usado para acessar um componente unico, retornando o componente "pelado")
x[[2]]
y[["double"]]
z[["transcendental"]]

##usando o $, lembre do dataframe(um tipo de lista especial), mostra somente um componente,
#mas de forma mais limitada, ja que precisa do nome dele
z$transcendental
#explicacao para a diferenca de se usar [] e [[]] 
#cap21 r for data science: http://r4ds.had.co.nz/vectors.html#lists-of-condiments

#exercicios
#1. use [], [[]] e $ para acessar o segundo componente da lista z
z["transcendental"]
z[["transcendental"]]
z$transcendental

length(z)
length(z$transcendental) #2
length(z["transcendental"]) #1
length(z[["transcendental"]]) #2

#2.
my_vec <- c(a = 1, b = 2, c = 3)
my_list <- list(a = 1, b = 2, c = 3)

my_vec[2:3]
my_vec[[2:3]]#error
my_vec[[2]]
my_vec$b #error

my_list[2:3]
my_list[[2]]
my_list$b

#vectorized operations
#exemplo: elevar ao quadrado inteiros comecando em 1 ate n de forma "tradicional":
n <- 5
res <- rep(NA_integer_, n)
for (i in seq_len(n)) {
  res[i] <- i^2
}
res

#no modo "R":
n <- 5
seq_len(n)^2

#o lado ruim: isso acontece para atomic vectors, mas geralmente nao acontece para lists
#faz sentido pq nao ha razoes para acreditar que o mesmo escopo de operacoes faz sentido 
#pra cada componente de uma lista. diferente de atomic vectors, elas sao heterogeneas

#uma demo usando as.list() para criar uma versao em lista de um atomic vector
## elementwise exponentiation of numeric vector works
exp(v_doub)
## put the same numbers in a list and ... this no longer works :(
(l_doub <- as.list(v_doub))
exp(l_doub)

#entonce como faz pra aplicar uma funcao elementwise em uma lista?
#qual é o analogo em lista para exp(v_doub)?
#ai usamos purr::map()! o primeiro argumento é a lista a ser operada
#o segundo é a funcao a ser aplicada
library(purrr)
map(l_doub, exp) #"mappeando a funcao exp() na lista l_doub"
#conceitualmente nos damos um loop pelos elementos da lista aplicando a funcao
my_list <- list(...)
my_output <- ## something of an appropriate size and flavor
  for(i in seq_along(my_list)) {
    my_output[[i]] <- f(my_list([[i]]))
  }
#o objetivo desse tutorial era mostrar como evitar escrever esses for loops explicitos