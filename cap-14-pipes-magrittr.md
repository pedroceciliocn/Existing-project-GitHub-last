cap 14 magrittr
================
pedro
30/11/2020

# Pipes com magrittr cap 14

``` r
library("magrittr")
```

## Alternativas ao Piping

Estorinha do livro:

> Little bunny Foo Foo  
> Went hopping through the forest  
> Scooping up the filed mice  
> And bopping them on the head  

``` r
#função fictícia
#foo_foo <-  little_bunny()
```

Usando uma função fictícia para cada verbo-chave: **hop()**, **scoop()**
e **bop()**, há quatro maneiras para recontar a história do coelhinho
Foo Foo:  

-   Salvar cada passo intermediário como um novo objeto
-   Sobrescrever o objeto original várias vezes
-   Compor funções
-   Usar o pipe

------------------------------------------------------------------------

### Passos intermediários

O modo mais simples é salvar cada passo como um objeto novo:

``` r
#foo_foo_1 <- hop(foo_foo, through = forest)
```
