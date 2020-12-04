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
> Went hopping through the forest  Scooping up the field mice  And
> bopping them on the head 

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
#foo_foo_2 <- hop(foo_foo_1, up = field_mice)
#foo_foo_3 <- hop(foo_foo_2, on = head)
```

O problema é que dessa forma, acada novo passo é necessário criar um
objeto intermediário novo, com nomes diferenciados apenas por algum
número ou sufixo, deixando o código cheio de nomes insignificantes. Além
disso, é necessário uma atenção maior a cada novo passo criado (e novo
sufixo portanto), errar o número de um dos objetos pode acarretar num
erro bobo.

*Agora uma observação sobre alocação de memória: o livro adverte que não
é recomendável gastar tempo se preocupando com isso proativamente, a
menos que a alocação seja realmente um problema ou limitação na
resolução de um problema. O R consegue trabalhar bem, meio que
automaticamente, nos casos mais simples e usuais.*

------------------------------------------------------------------------

### Sobrescrever o original

Ao invés de criar novos objetos intermediários para cada passo, há a
possibilidade de se substituir o objeto original sempre que ele for
“atualizado”:

``` r
#foo_foo <- hop(foo_foo, through = forest)
#foo_foo <- scoop(foo_foo, up = field_mice)]
#foo_foo <- bop(foo_foo, on = head)
```

Essa alternativa é mais simples e também é reduzida (requere menos
código digitado) em relação à ultima (passos intermediários), contudo,
identificar um erro e tornar o código mais eficiente se torna mais
complicado, pois a cada teste se faz necessário a reexecução do pipeline
todo desde o começo. Além disso, o objeto mudando e sendo atualizado a
cada linha, torna obscuro e incerto o que muda a cada em cada uma dessas
atualizações.

------------------------------------------------------------------------

### Composição de Função

Mais uma abordagem é juntar chamadas de função ao invés das atribuições:

``` r
#bop(
# scoop(
#   hop(foo_foo, through = forest),
#   up = field_mice
# ),
# on = head
#)
```

A desvantagem agora é a maneira como se lê uma função, de dentro pra
fora e da direita para a esquerda (e também o fato de que os argumentos
acabam ficando espalhados: “problema do sanduíche Dagwood”). Em suma,
ele é difícil de ler e entender.

------------------------------------------------------------------------

e finalmente, \#\#\# Usar o Pipe

``` r
#foo_foo %>% 
#hop(through = forest) %>% 
#  scoop(up = field_mouse) %>% 
#  bop(on = head)
```
