library(tidyverse)

#visualizando distribuicoes
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut)) #distribuicao de uma variavel categorica = grafico de barras

diamonds %>% #contando os valores manualmente (as barras exibem o nmero de observacoes com cada valor de x)
  count(cut)

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5) #distribuicao de uma variavel continua = histograma

diamonds %>% 
  count(cut_width(carat, 0.5)) #calculando a mao combinando dplyr::count() e ggplot2::cut_width()
#um histograma divide o eixo x em caixas (bins) igualmente espacadas, e entao usa a altura de cada barra para
#exibir o numero de observacoes que caem em cada caixa.

smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1) #grafico anterior focando apenas nos diamantes com um tamanho menor que 3 quilates (carats) e com binwidth menor

ggplot(data = smaller, mapping = aes(x = carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1) #mesmo grafico mas usando o count em linhas (ao inves de barras) e o cut como parametro estetico (cada corte com uma cor)

#valores tipicos
ggplot(smaller, mapping = aes(carat)) +
  geom_histogram(binwidth = 0.01)
#perguntas que podem ser feitas:
# pq ha mais diamantes em quilates inteiros e fracoes comuns de quilates?
# pq ha mais diamantes levemente a direita de cada pico do que levemente a esquerda de cada pico?
# pq nao existem diamantes com mais de 3 quilates?

#clusters de valores similares sugerem que existem subgrupos em seus dados. para entende-los, pergunte:
# quais a semelhancas entre as observacoes dentro de cada cluster?
# quais sao as diferencas entre as observacoes de clusters separados?
# como voce pode explicar ou descrever os clusters?
# pq a aparencia dos clusters pode ser enganosa?

ggplot(smaller, mapping = aes(carat)) + #########LOMBRAAAAAAAAAA
  geom_histogram(binwidth = 0.01) +
  facet_wrap(~ cut, nrow = 2)


ggplot(faithful, mapping = aes(eruptions)) +
  geom_histogram(binwidth = 0.25) #grafico mostrando a duracao em minutos de 272 erupcoes de um determinado geiser. Os tempos parecem estar agrupados em 
#2 clusters (ha erupcoes curtas e longas, mas poucas no meio disso)

#valores incomuns
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50)) #limitando o count(eixo y) de 0 ate 50

#o ggplot2 tambem tem esses argumentos, mas descartam os dados fora dos limites (ponto/conjunto fechado/aberto)
#e possivel ver que ha 3 valores fora do comum: 0, ~30 e ~60
#arrancando eles com dplyr
unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  arrange(y)
unusual

#a variavel y mede uma das 3 dimensoes dos diamantes em mm. Diamantes nao podem ter, obviamente, 0mm numa das dimensoes, logo
#houve algum erro. Sobre os diamantes com ~30 e ~60, podemos suspeitar tambem, pois eles seriam enormes e seus precos nao parecem
#condizer com o tamanho deles. Tambem deve ter sido um erro. entonce é bom repetir as analises com e sem os pontos fora da curva
#para medir seus impactos nela e decidir se podem ou nao ser retirados/substituidos por exemplo por valores faltantes.

#exercicios
#1. explore a distribuicao de cada variavel x, y e z em diamonds. O que voce aprende? pense sobre um diamante e como voce pode deter-
#minar qual dimensao é o comprimento, a largura e a profundidade.
summary(select(diamonds, x, y, z))

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = x), binwidth = 0.01)

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.01)

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = z), binwidth = 0.01)

summary(select(diamonds, x, y, z))

filter(diamonds, x == 0 | y == 0 | z == 0)

diamonds %>%
  arrange(desc(y)) %>%
  head()

diamonds %>%
  arrange(desc(z)) %>%
  head()

ggplot(diamonds, aes(x = x, y = y)) +
  geom_point()

ggplot(diamonds, aes(x = x, y = z)) +
  geom_point()

ggplot(diamonds, aes(x = y, y = z)) +
  geom_point()

filter(diamonds, x > 0, x < 10) %>%
  ggplot() +
  geom_histogram(mapping = aes(x = x), binwidth = 0.01) +
  scale_x_continuous(breaks = 1:10)

filter(diamonds, y > 0, y < 10) %>%
  ggplot() +
  geom_histogram(mapping = aes(x = y), binwidth = 0.01) +
  scale_x_continuous(breaks = 1:10)

filter(diamonds, z > 0, z < 10) %>%
  ggplot() +
  geom_histogram(mapping = aes(x = z), binwidth = 0.01) +
  scale_x_continuous(breaks = 1:10)

summarise(diamonds, mean(x > y), mean(x > z), mean(y > z))



#2. explore a distribuicao de price. algo incomum? (dica: binwidth)
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 5000) #tem mais diamantes com preco baixo do que alto
#aumentando o binwidth fica mais claro a distribuicao do preco. diminuindo aparecem buracos estranhos (100 pra baixo)

unusual_price_count <- diamonds %>% 
  filter(price<=2500) %>% 
  arrange(price)
unusual_price_count

ggplot(unusual_price_count) +
  geom_histogram(mapping = aes(x = price), binwidth = 5) #tem um buraco na distribuicao, nao existem diamantes custando 1500 usd


########################
ggplot(filter(diamonds, price < 2500), aes(x = price)) +
  geom_histogram(binwidth = 10, center = 0)

ggplot(filter(diamonds), aes(x = price)) +
  geom_histogram(binwidth = 100, center = 0)

diamonds %>%
  mutate(ending = price %% 10) %>%
  ggplot(aes(x = ending)) +
  geom_histogram(binwidth = 1, center = 0)

diamonds %>%
  mutate(ending = price %% 100) %>%
  ggplot(aes(x = ending)) +
  geom_histogram(binwidth = 1)

diamonds %>%
  mutate(ending = price %% 1000) %>%
  filter(ending >= 500, ending <= 800) %>%
  ggplot(aes(x = ending)) +
  geom_histogram(binwidth = 1)

#3. quantos diamantes tem 0.99 quilates? quantos tem 1 quilate? qual voce acha que e a causa da diferenca?
lessequal1 <- diamonds %>% 
  filter(carat<=1) %>% 
  count(carat) %>% 
  arrange(desc(carat))
lessequal1

around0991 <- diamonds %>% 
  filter(carat<=1, carat>=0.99) %>% 
  count(carat) %>% 
  arrange(desc(carat))
around0991

logoacima1 <- diamonds %>% #logo acima de 1 (1.01) tem mais de 2000 diamantes
  filter(carat<=1.1) %>% 
  count(carat) %>% 
  arrange(desc(carat))
logoacima1

diamonds %>%
  filter(carat >= 0.9, carat <= 1.1) %>%
  count(carat) %>%
  print(n = Inf)

#mais de 1500 tem 1 quilate, e apenas 23 tem 0.99
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.05) +
  coord_cartesian(xlim = c(0, 2))

#muito provavelmente ha alguma maneira de filtrar os diamantes com quilate inteiro ou pouco acima, algum tipo de incentivo
#provavelmente monetario que leve a isso, fazendo com que haja alguma manipulacao talvez ou no processo de mineracao/separacao/corte
#pra que fique sempre proximo mas acima desse valor inteiro

cor(x=diamonds$carat, y=diamonds$price, use = "everything", method = c("pearson")) #correlacao alta entre preco e quilate

logoacima1 <- diamonds %>% #logo acima de 1 (1.01) tem mais de 2000 diamantes
  filter(carat<=1.1) %>% 
  count(carat) %>% 
  arrange(desc(carat)) %>%  
logoacima1

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = price)) +
  coord_cartesian(xlim = c(100, 5000), ylim = c(0, 3000))

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = price)) +
  xlim(100, 5000) +
  ylim(0, 3000)

#valores faltantes
#valores incomuns nos dados podem ser:
#retirados (toda a linha com valores estranhos) - nao recomendado
diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))

#substituir os valores incomuns por valores faltantes:
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y)) #quando o y for menor que 3 ou maior que 20, um NA é colocado no lugar do valor
#senao, ele permanece y

ggplot(diamonds2, mapping = aes(x = x, y = y)) +
  geom_point()
#foram removidos os NAs automaticamente, por isso o aviso (ggplot ja faz isso)
#pra suprimir o aviso, use na.rm = TRUE:
ggplot(diamonds2, mapping = aes(x = x, y = y)) +
  geom_point(na.rm = TRUE)


nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time), #NAs indicam que os voos foram cancelados, por isso foi criada a variavel cancelled
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot(mapping = aes(sched_dep_time)) +
  geom_freqpoly(
    mapping = aes(color = cancelled),
    binwidth = 1/4
  )
#esse grafico nao é ideal, pois ha muito mais voos nao cancelados do que cancelados

#exercicios
#1. oq acontece com valores faltantes em um histograma?oq ocorre com valores faltantes em
#um grafico de barras?pq ha uma diferenca?

#no histograma NAs sao removidos. O x em aes precisa ser numerico e stat_bin() agrupa as observacoes pelo range dos bins.
#como o valor numerico das observacoes NA sao desconhecidos, eles nao podem ser colocados em um bin particular,
#entao sao ignoradas/removidas
diamonds2 <- diamonds %>%
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

ggplot(diamonds2, aes(x = y)) +
  geom_histogram()

#com geom_bar() os NAs sao tratados como uma outra categoria
#o x em aes em geom_bar() requere uma variavel discreta (categorica), e NAs agem como outra categoria
diamonds %>%
  mutate(cut = if_else(runif(n()) < 0.1, NA_character_, as.character(cut))) %>%
  ggplot() +
  geom_bar(mapping = aes(x = cut))

#o que na.rm = TRUE faz em mean() e sum()?
#remove os NAs para o calculo
mean(c(0, 1, 2, NA), na.rm = TRUE)
mean(c(0, 1, 2, NA)) #deu NA

sum(c(0, 1, 2, NA), na.rm = TRUE)
sum(c(0, 1, 2, NA)) #deu NA

#Covariacao
##uma variavel categorica e continua
ggplot(diamonds, mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

ggplot(diamonds) +
  geom_bar(mapping = aes(x = cut))

ggplot(diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)


ggplot(diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()


ggplot(mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

#reordenando class com base no valor medio de hwy
ggplot(mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()


#exercicios
#1. 
nycflights13::flights %>% 
  mutate(
    cancelled = is.na(dep_time), #NAs indicam que os voos foram cancelados, por isso foi criada a variavel cancelled
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + sched_min / 60
  ) %>% 
  ggplot() +
  geom_boxplot(
    mapping = aes(x = cancelled, y = sched_dep_time)
  ) +
  coord_flip()

#2. 
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_point()


ggplot(diamonds, mapping = aes(x = carat, y = price)) +
  geom_boxplot(aes(group = cut_width(carat, 0.1)))

diamonds %>% 
mutate(color = fct_rev(color)) %>% 
  ggplot(aes(x = color, y = price)) +
  geom_boxplot()#correlacao negativa e fraca

ggplot(data = diamonds) +
  geom_boxplot(mapping = aes(x = clarity, y = price)) #correlacao negativa e fraca

#é possivel ver que carat parece ser o melhor preditor do preco
#qual sua relacao com os tipos de corte?
ggplot(diamonds, aes(x = cut, y = carat)) +
  geom_boxplot()
#ha uma correlacao negativa (os diamantes com maior quilate tem o pior corte)
#a explicacao poderia ser por conta do tamanho (uma pedra maior pode ser vendida com um corte pior,
#ja uma menor teria um corte mais refinado)

#3.
ggplot(data = mpg) +
  geom_boxploth(mapping = aes(y = reorder(class, hwy, FUN = median), x = hwy))

#4. 
library(lvplot)
ggplot(diamonds, mapping = aes(x = cut, y = price)) +
  geom_lv()

#5.
ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram() +
  facet_wrap(~cut, ncol = 1, scales = "free_y")

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_violin() +
  coord_flip()

#6. alternativas ao jitter usando ggbeeswarm
# sao dois metodos:
#geom_quasirandom() que produz graficos misturando jitter com violin
#(tem varios metodos diferentes para determinar onde ficam os pontos gerados)

#geom_beeswarm() produz um grafico similar a um violin mas organizando
#os pontos de forma diferente (sobrepondo e alinhando?)


library(ggbeeswarm)
ggplot(data = mpg) +
  geom_quasirandom(mapping = aes(
    x = reorder(class, hwy, FUN = median),
    y = hwy
  ))

ggplot(data = mpg) +
  geom_quasirandom(
    mapping = aes(
      x = reorder(class, hwy, FUN = median),
      y = hwy
    ),
    method = "tukey"
  )

ggplot(data = mpg) +
  geom_quasirandom(
    mapping = aes(
      x = reorder(class, hwy, FUN = median),
      y = hwy
    ),
    method = "tukeyDense"
  )

ggplot(data = mpg) +
  geom_quasirandom(
    mapping = aes(
      x = reorder(class, hwy, FUN = median),
      y = hwy
    ),
    method = "frowney"
  )

ggplot(data = mpg) +
  geom_quasirandom(
    mapping = aes(
      x = reorder(class, hwy, FUN = median),
      y = hwy
    ),
    method = "smiley"
  )

ggplot(data = mpg) +
  geom_beeswarm(mapping = aes(
    x = reorder(class, hwy, FUN = median),
    y = hwy
  ))



#duas variaveis categoricas - contar o numero de observacoes de cada combinacao
ggplot(diamonds) +
  geom_count(aes(x = cut, y = color))

#outra abordagem
diamonds %>% 
  count(color, cut)
#plot
diamonds %>% 
  count(color, cut) %>% 
  ggplot(aes(x = color, y = cut)) +
  geom_tile(aes(fill = n))

#alternativas para ordenar as variaveis categoricas e graficos interativos
install.packages("seriation")
install.packages("d3heatmap")
install.packages("heatmaply")

#exercicios
#1.
#usar a proporcao entre n e sum(n) 

library(viridis)
diamonds %>%
  count(color, cut) %>%
  group_by(color) %>%
  mutate(prop = n / sum(n)) %>%
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = prop)) +
  scale_fill_viridis(limits = c(0, 1)) # from the viridis colour palette library

diamonds %>%
  count(color, cut) %>%
  group_by(cut) %>%
  mutate(prop = n / sum(n)) %>%
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = prop)) +
  scale_fill_viridis(limits = c(0, 1))

#2.
flights %>%
  group_by(month, dest) %>%
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  ggplot(aes(x = factor(month), y = dest, fill = dep_delay)) +
  geom_tile() +
  labs(x = "Month", y = "Destination", fill = "Departure Delay")

flights %>%
  group_by(month, dest) %>%
  summarise(dep_delay = mean(dep_delay, na.rm = TRUE)) %>%
  group_by(dest) %>%
  filter(n() == 12) %>%
  ungroup() %>%
  mutate(dest = reorder(dest, dep_delay)) %>%
  ggplot(aes(x = factor(month), y = dest, fill = dep_delay)) +
  geom_tile() +
  scale_fill_viridis() +
  labs(x = "Month", y = "Destination", fill = "Departure Delay")

#3.pq é melhor usar aes(x = color, y = cut) em vez do contrario?
diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(y = color, x = cut)) +
  geom_tile(mapping = aes(fill = n))

diamonds %>%
  count(color, cut) %>%
  ggplot(mapping = aes(y = cut, x = color)) +
  geom_tile(mapping = aes(fill = n))
#é melhor deixar o maior numero de categorias (ou as categorias com nomes maiores)
#no eixo y



#Duas variaveis continuas:
ggplot(diamonds) +
  geom_point(aes(x = carat, y = price))

#como sao muitos pontos, eles se sobrepoem a medida que o tamanho
#do conjunto de dados aumenta
#entao é necessario usar a estetica alpha (transparencia)
ggplot(diamonds) +
  geom_point(aes(x = carat, y = price), alpha = 1/100)

#mas usar transparencia pode ser desafiador para conjuntos de dados enormes
#outra solucao é usar bin
#geom_bin2d() e geom_hex() dividem o plano de coordenadas em bins 2d
#e entao usam a cor de preenchimento para exibir quantos pontos caem em cada bin.
install.packages("hexbin")
library(hexbin)
ggplot(smaller) +
  geom_bin2d(aes(x = carat, y = price))
#ou
ggplot(smaller) +
  geom_hex(aes(x = carat, y = price))

#outra opcao é fazer o bin passar de uma variavel continua para agir como uma categorica
#assim da pra usar tecnicas de uma combinacao entre variavel categorica e continua
ggplot(smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(aes(group = cut_width(carat, 0.1)))
#foi criado o bin carat e entao pra cada grupo foi exibido um boxplot
#cut_width(x, width) divide x em bins de largura width
#os boxplots parecem iguais independente do numero de observacoes (mesma largura), so mudando a altura e o numero de outliers.
#para mostrar melhor, é necessario tornar a largura deles proporcional ao numero de pontos com varwidth = TRUE.
#outra abordagem é exibir aproximadamente o mesmo numero de pontos em cada bin. Esse é o trabalho de cut_number().
ggplot(smaller, mapping = aes(x = carat, y = price)) +
  geom_boxplot(aes(group = cut_number(carat, 20)))


#exercicios
#1.
ggplot(diamonds, mapping = aes(color = cut_number(carat, 5), x = price)) +
  geom_freqpoly() +
  labs(x = "Price", y = "Count", color = "Carat")

ggplot(diamonds, mapping = aes(color = cut_width(carat, 1, boundary = 0), x = price)) +
  geom_freqpoly() +
  labs(x = "Price", y = "Count", color = "Carat")

#cut_widht() e cut_number() dividem a variavel em grupos. Quando se usa
#o cut_width(), precisamos escolher a largura e o numero de bins serao calculados
#automaticamente. Quando usamos cut_number(), precisamos especificar o numero de bins,
#e as larguras sao calculadas automaticamente.

#em ambos os casos, nos queremos escolher as larguras dos bins e o numero deles
#para serem largos o suficiente para uma melhor observacao (agregando e removendo ruidos),
#mas nao tao largo
#se cores categoricas forem usadas, nao mais do que 8 poderiam ser usadas 
#para que se mantenha uma distincao entre elas. Usando cut_number(), carat
#foi dividido em 5 bins

#usando cut_width tem que se ter cuidado com o valor, pois por exemplo, usando 0.5, muitos grupos
#sao criados, dificultando a visualizacao. Entao foi usado uma largura de 1

#2.
ggplot(diamonds, aes(x = cut_number(price, 10), y = carat)) +
  geom_boxplot() +
  coord_flip() +
  xlab("Price")

ggplot(diamonds, aes(x = cut_width(price, 2000, boundary = 0), y = carat)) +
  geom_boxplot(varwidth = TRUE) +
  coord_flip() +
  xlab("Price")

#3.

#4.
ggplot(diamonds, aes(x = carat, y = price)) +
  geom_hex() +
  facet_wrap(~cut, ncol = 1) +
  scale_fill_viridis()

ggplot(diamonds, aes(x = cut_number(carat, 5), y = price, colour = cut)) +
  geom_boxplot()

ggplot(diamonds, aes(colour = cut_number(carat, 5), y = price, x = cut)) +
  geom_boxplot()

#5.
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = x, y = y)) +
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))



#PADROES E MODELOS
ggplot(faithful) +
  geom_point(aes(x = eruptions, y = waiting)) #exibe dois clusters

library(modelr)
mod < lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))

ggplot(diamonds2) +
  geom_point(aes(x = carat, y = resid))


ggplot(diamonds2) +
  geom_boxplot(aes(x = cut, y = resid))


#chamadas ggplot2
ggplot(data = faithful, mapping = aes(x = eruptions)) +
  geom_freqpoly(binwidth = 0.25)

ggplot(faithful, aes(eruptions)) +
  geom_freqpoly(binwidth = 0.25)


diamonds %>% 
  count(cut, clarity) %>% 
  ggplot(aes(clarity, cut, fill = n)) +
  geom_tile()
