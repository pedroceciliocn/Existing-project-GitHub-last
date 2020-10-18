library(tidyverse)
mpg

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))


ggplot(data = df_infalunos)
table(df_infalunos)
df_infalunos2 <- data.frame(table(df_infalunos))
ggplot(data = df_infalunos2) +
  geom_(mapping = aes(x = Freq, y = df_infalunos))
# exercícios
#1. Execute ggplot(data = mpg). O que você vê? 
#R: Um fundo cinza vazio

#2. Quantas linhas existem em mtcars? Quantas colunas?
#R: nrow(mtcars)
#   32 linhas
#   ncol(mtcars)
#   11 colunas
# ou glimpse() (mostra num data frame)


#3. O que a variável drv descreve? Leia a ajuda de ?mpg para descobrir.
#R: o tipo de tração nas rodas do modelo especifico de carro. 
#   f para tração nas rodas da frente
#   r nas de trás
#   4 para tração nas 4 rodas

#4. Faça um gráfico de dispersão de hwy versus cyl.
#R: 

ggplot(data = mpg) +
  geom_point(mapping = aes(x = hwy, y = cyl))

#5. O que acontece se você fizer um gráfico de dispersão de class versus drv? Por que esse gráfico não é útil?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = class, y = drv))
#R: são mostrados muito poucos pontos. Um gráfico de dispersão não é muito útil para mostrar essas duas variávels, pois ambas são
# categóricas, normalmente usadas paraum pequeno número de valores, há um número limitado de combinações únicas entre x e y que
# podem ser mostradas e um grafico de dispersão simples não consegue mostrar quantas observações foram vistas para cada um dos
# valores de x e y

# um modo melhor de visualizar seria usando o código
ggplot(mpg, aes(x = class, y = drv)) +
  geom_count()


################################################
count(mpg, drv, class)


########## TEMPLATE #########################
ggplot(data = #<DATA>) +
  #<GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))
    
    
    
### pontos estranhos que fogem ao padrão (tamanho do motor x eficiência de consumo)
  # mapeando as classes de carros com a estética de cor (para verificar de que classe são os carros "estranhos")
  ggplot(data = mpg) +
    geom_point(mapping = aes(x = displ, y = hwy, color = class))

#mapeando class à estética de tamanho

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

#o aviso foi dado pois não é uma boa ideia mapear uma variável não ordenada (class) à uma estética ordenada (size)

# usando estetica alpha (transparencia)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# usando estetica shape (formatos)
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# cores
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")



ggplot(mpg, aes(x = displ, y = hwy, colour = cty)) +
  geom_point()
ggplot(mpg, aes(x = displ, y = hwy, size = cty)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, colour = hwy, size = displ)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, colour = displ < 5)) +
  geom_point()
?mpg


#facetas
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)




ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)


ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)


# exercicios
#1
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ cty, nrow = 2)

#2
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = drv, y = cyl))

#3 Que gráficos o código faz a seguir? o que . faz?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

#O simbolo . ignora essa dimensao quando faz os subgráficos (as facetas). No caso, drv ~. é facetado por valores do drv no eixo y
#enquanto, . ~ cyl faceta os valores de cyl no eixo x 


#4 vantagens e desvantagens de usar facetas ao inves de cores?
#nova alternativa de plot
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)

#primeira alternativa de plot com cores
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

#https://jrnold.github.io/r4ds-exercise-solutions/data-visualisation.html#exercise-3.5.1



#objetos geometricos

#pontos
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))


#linha suave
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

#uma linha diferente pra cada valor da variavel mapeada (separa os carros em tres linhas baseadas em seus valores drv, a tracao do carro) )
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))



ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))


#uma linha pra cada tipo de tracao
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

#uma cor pra cada linha com tipo de tracao
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, color = drv),
              show.legend = FALSE
              )


#varios geoms no mesmo grafico
#pode causar duplicacao no codigo
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

#usando mapeamentos globais que se aplicam a cada geom do grafico

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

#agora e possivel mapear individualmente cada camada, sobrepondo ou ampliando os mapeamentos globais

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth()


#usando a mesma logica pra especificar um conjunto de dados diferente pra cada camada (a linha suave aqui exibe apenas um subconjunto do conjunto de dados mpg, os carros subcompactos)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(
    data = filter(mpg, class == "subcompact"),
    se = FALSE
  )
  
#EXERCICIOS

#1 Que geom voce usaria para desenhar um grafico de linha? Um diagrama de caixa? um histograma? um grafico de area?

#line chart: geom_line()
#boxplot: geom_boxplot()
#histogram: geom_histogram()
#area chart: geom_area()

#2 o se é o erro padrao (o contorno/sombra cinza das linhas)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, colour = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, colour = drv)) +
  geom_point() +
  geom_smooth()

#3 show.legend não a legenda https://jrnold.github.io/r4ds-exercise-solutions/data-visualisation.html#exercise-3.6.3
ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, colour = drv),
    show.legend = FALSE
  )

#4 mostra ou nao o erro padrao (contorno/sombra)

#5 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(
    data = mpg,
    mapping = aes(x = displ, y = hwy)
  ) +
  geom_smooth(
    data = mpg,
    mapping = aes(x = displ, y = hwy)
  )


#6
#grafico 1
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(se = FALSE)

#grafico 2
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(mapping = aes(group = drv), se = FALSE)

#grafico 3
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(mapping = aes(color = drv), se = FALSE)


#ou
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)


#grafico 4
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(se = FALSE)

#grafico 5
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(mapping = aes(linetype = drv), se = FALSE)

#grafico 6
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(size = 4, color = "white") +
  geom_point(mapping = aes(color = drv))

#transformacoes estatisticas

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))



demo <- tribble(
  ~a,       ~b,
  "bar_1", 20,
  "bar_2", 30,
  "bar_3", 40
)

ggplot(data = demo) +
  geom_bar(mapping = aes(x = a, y = b), stat = "identity")




#sobrescrevendo o mapeamento padrao (exibindo o grafico de barras de proportion em vez de count)
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

#resumo do que esta sendo calculado
ggplot(data = diamonds) +
  stat_summary(mapping = aes(x = cut, y = depth),
               fun.ymin = min,
               fun.ymax = max,
               fun.y = median
               )


#exemplos stat_summary

ggplot(mtcars, aes(cyl, mpg)) +
  geom_point() +
  stat_summary(fun.data = "mean_cl_boot", colour = "red", size = 2)

ggplot(mtcars, aes(cyl, mpg)) +
  geom_point() +
  stat_summary(fun.y = "median", colour = "red", size = 2, geom = "point")

ggplot(mtcars, aes(cyl, mpg)) +
  geom_point() +
  stat_summary(fun.y = "mean", colour = "red", size = 2, geom = "point")

ggplot(mtcars, aes(cyl, mpg)) +
  geom_point() +
  aes(colour = factor(vs)) +
  stat_summary(fun.y = mean, geom="line")

ggplot(mtcars, aes(cyl, mpg)) +
  geom_point() +
  stat_summary(fun.y = mean, fun.ymin = min, fun.ymax = max,
               colour = "red")


ggplot(diamonds, aes(cut)) +
  geom_bar()

ggplot(diamonds, aes(cut)) +
  geom_bar() +
  stat_summary_bin(aes(y = price), fun.y = "mean", geom = "bar")




#exercicios
#1 https://jrnold.github.io/r4ds-exercise-solutions/data-visualisation.html#exercise-3.7.1

#The default geom for stat_summary() is geom_pointrange(). 
#The default stat for geom_pointrange() is identity() 
#but we can add the argument stat = "summary" to use stat_summary() instead of stat_identity().

ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
    stat = "summary"
  )

#The resulting message says that stat_summary() uses the mean and sd to calculate the middle point and endpoints of the line.
#However, in the original plot the min and max values were used for the endpoints.
#To recreate the original plot we need to specify values for fun.ymin, fun.ymax, and fun.y.
#
ggplot(data = diamonds) +
  geom_pointrange(
    mapping = aes(x = cut, y = depth),
    stat = "summary",
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )


#2 diferencas geom_col e geom_bar? https://jrnold.github.io/r4ds-exercise-solutions/data-visualisation.html#exercise-3.7.2


#3 https://jrnold.github.io/r4ds-exercise-solutions/data-visualisation.html#exercise-3.7.3

#4 https://jrnold.github.io/r4ds-exercise-solutions/data-visualisation.html#exercise-3.7.4

#5 
ggplot(data = diamonds) +
geom_bar(mapping = aes(x = cut, y = ..prop..))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

ggplot(data = diamonds) +
  geom_bar(aes(x = cut, y = ..count.. / sum(..count..), fill = color))



#ajustes de posicao
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, color = cut))

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut))


#coloriu o grafico usando outra variavel (clarity)
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity))


ggplot(data = diamonds, mapping =  aes(x = cut, fill = clarity)) +
         geom_bar(alpha = 1/5, position = "identity")

ggplot(data = diamonds, mapping =  aes(x = cut, color = clarity)) +
  geom_bar(fill = NA, position = "identity")


ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "stack")

ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

ggplot(data = mpg) +
  geom_jitter(mapping = aes(x = displ, y = hwy))



#exercicios
#1 qual o problema do grafico? como melhora-lo?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point(position = "jitter")

 # ou

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(mapping = aes(color = class))

#2 https://jrnold.github.io/r4ds-exercise-solutions/data-visualisation.html#exercise-3.8.2
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point(position = position_jitter())

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(width = 0)

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(width = 20)

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(width = 5)

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(height = 0)


ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(height = 20)

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(height = 5)


ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(mapping = aes(color = class), height = 5)

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(mapping = aes(color = class), width = 5)

#3 compare geom_jitter e geom_count

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy, color = class)) +
  geom_jitter()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy, color = class)) +
  geom_count()


#When width = 0 and height = 0, 
#there is neither horizontal or vertical jitter, 
#and the plot produced is identical to the one produced with geom_point().

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_jitter(height = 0, width = 0)

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point()


#4 qual o ajuste de posicao padrao para geom_boxplot? crie uma vizualizacao do conjunto de dados mpg que demonstre isso

ggplot(data = mpg, aes(x = drv, y = hwy, colour = class)) +
  geom_boxplot()

ggplot(data = mpg, aes(x = drv, y = hwy, colour = class)) +
  geom_boxplot(position = "identity")

#sistemas de coordenadas
#coord_flip troca os eixos

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()


#coord_quickmap configura a proporcao de tela corretamente para mapas

nz <- map_data("nz")

ggplot(data = nz, mapping = aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black")


ggplot(data = nz, mapping = aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()

#coord_polar usa coordenadas polares


bar<- ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut), show.legend = FALSE, width = 1) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

#exercicios
#1 transforme um grafico de barras empilhadas em um grafico de pizza usando coord_polar

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut)) +
  coord_polar()


ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge") +
  coord_polar()


ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y")


#2 ?labs
#The labs function adds axis titles, plot titles, and a caption to the plot.


ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip() +
  labs(
    y = "Highway MPG",
    x = "Class",
    title = "Highway MPG by car class",
    subtitle = "1999-2008",
    caption = "Source: http://fueleconomy.gov"
  )

#The arguments to labs() are optional, so you can add as many or as few of these as are needed.


ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip() +
  labs(
    y = "Highway MPG",
    x = "Year",
    title = "Highway MPG by car class"
  )

#usando ggtile
ggplot(mpg, aes(x = factor(1), fill = drv)) +
  geom_bar(width = 1) +
  coord_polar(theta = "y") +
  ggtitle("grafico de pizza", subtitle = "issai")


#4 diferencas coord_quickmap e coord_map
#o primeiro usa o mapa aberto sem a curvatura da terra, ja o segundo mantem ela. A distorcao e diferente entre eles.

#5 https://jrnold.github.io/r4ds-exercise-solutions/data-visualisation.html#exercise-3.9.4

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed()