#### filtrar linhas com filter()
filter(flights, month == 1, day == 1)

jan1 <- filter(flights, month == 1, day == 1)

(dec25 <- filter(flights, month == 12, day == 25))


#### comparações
filter(flights, month = 1)
##Error: `month` (`month = 1`) must not be named, do you need `==`?

sqrt(2) ^ 2 == 2
## [1] FALSE

1/49 * 49 == 1
## [1] FALSE

near(sqrt(2) ^ 2, 2)
##[1] TRUE
# usando o == no primeiro caso, dá falso pois a precisão é finita (muitas casas, ou infinitas após a vírgula)
#o near serve como um "tende a", "se aproxima de"

near(1/49 * 49, 1)
##[1] TRUE

#### operadores logicos
filter(flights, month == 11 | month == 12)

filter(flights, month == 11 | 12) # modo errado, ele usa o 11 | 12 como uma expressao que é avaliada como TRUE, e daí
# como TRUE é 1, mostra todos os dados referentes ao mês 1 (janeiro)

# forma de contornar isso é usando x %in% y que seleciona toda linha em que x seja um dos valores de y

(nov_dec <- filter(flights, month %in% c(11,12)))

### !(x & y) é o mesmo que !x | !y
### !(x | y) é o mesmo que !x & !y

# encontrando voos que não estivesem atrasados (chegada ou partida) em mais de duas horas

filter(flights, !(arr_delay > 120 | dep_delay > 120))
#ou
filter(flights, arr_delay <= 120, dep_delay <= 120)

#considere usar variáveis explícitas no lugar das expressoes

#### valores faltantes (NA)
NA > 5
##[1] NA

10 == NA
##[1] NA

NA + 10
##[1] NA

NA / 2
##[1] NA

NA == NA
##[1] NA

#i1 é a idade de Maria. Nós não sabemos a idade dela.
i1 <- NA
#i2 é a idade de João. Não sabemos a idade dele.
i2 <- NA
# João e Maria tem a mesma idade?
i1 == i2
##[1] NA #Não sabemos!

#para determinar se um valor está faltando, use is.na()

is.na(i1)
##[1] TRUE

# pedindo que os valores NA sejam incluidos no filter()
df <- tibble(i1 = c(1, NA, 3))
filter(df, i1 > 1)
filter(df, is.na(i1) | i1 > 1)

#### EXERCICIOS
#1 Enontre os voos que:
  #a. tiveram um atraso de duas horas ou mais na chegada (arr_delay)
filter(flights, arr_delay >= 120)
  #b. foram para Houston (IAH ou HOU) (dest)
filter(flights, dest == "IAH" | dest == "HOU")
#ou
filter(flights, dest %in% c("IAH", "HOU"))

  #c. foram operados pela United, American ou Delta (carrier)
airlines
### A tibble: 16 x 2
##carrier name                       
##<chr>   <chr>                      
##1 9E      Endeavor Air Inc.          
##2 AA      American Airlines Inc.     
##3 AS      Alaska Airlines Inc.       
##4 B6      JetBlue Airways            
##5 DL      Delta Air Lines Inc.       
##6 EV      ExpressJet Airlines Inc.   
##7 F9      Frontier Airlines Inc.     
##8 FL      AirTran Airways Corporation
##9 HA      Hawaiian Airlines Inc.     
##10 MQ      Envoy Air                  
##11 OO      SkyWest Airlines Inc.      
##12 UA      United Air Lines Inc.      
##13 US      US Airways Inc.            
##14 VX      Virgin America             
##15 WN      Southwest Airlines Co.     
##16 YV      Mesa Airlines Inc.      
filter(flights, carrier == "UA" | carrier == "AA" | carrier == "DL")
#ou
filter(flights, carrier %in% c("UA", "AA", "DL"))

  #d. Partiram em julho, agosto e setembro
filter(flights, month == 7 | month == 8 | month == 9)
#ou
filter(flights, month >= 7, month <= 9)
#ou
filter(flights, month %in% 7:9)


  #e. Chegaram com mais de duas horas de atraso, mas nao sairam atrasados
filter(flights, arr_delay >= 120 & dep_delay <= 0)
#ou
filter(flights, arr_delay > 120, dep_delay <= 0)


  #f. Atrasaram pelo menos uma hora, mas compensaram mais de 30 minutos durante o trajeto
filter(flights, dep_delay >= 60, dep_delay - arr_delay > 30)

  #g. Sairam entre meia-noite e 6h (incluindo esses horarios) o tempo é representado de maneira diferente
# meia noite é 2400, 6h é 600
summary(flights$dep_time) #verificando como é mostrada a hora
filter(flights, dep_time <= 600 | dep_time == 2400)

#usando operador %%
c(600, 1200, 2400) %% 2400
filter(flights, dep_time %% 2400 <= 600)


#2. outro ajudante de filtragem do dplyr é between(). O que ele faz? Da pra simplificar alguma das questoes anteriores?
#https://jrnold.github.io/r4ds-exercise-solutions/transform.html#exercise-5.2.2
#The expression between(x, left, right) is equivalent to x >= left & x <= right.
filter(flights, between(month, 7, 9))

#3. Quantos voos tem um dep_time faltante? Que outras variaves estao faltando? O que essas linhas podem representar?
filter(flights, is.na(dep_time))
# arr_time esta sempre com NA, ou seja, aparentemente foram voos cancelados


#4. Por que NA ^ 0não é um valor faltante? Por que NA | TRUE nao é um valor faltante? 
#Por que FALSE & NA nao é um valor faltante?
#https://jrnold.github.io/r4ds-exercise-solutions/transform.html#exercise-5.2.4



#### Ordenar linhas com arrange()
arrange(flights, year, month, day)

arrange(flights, desc(arr_delay)) #organiza arr_delay em ordem decrescente

# valores faltantes sao sempre colocados no final:
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
### A tibble: 3 x 1
##      x
##  <dbl>
##1     2
##2     5
##3    NA


#### EXERCICIOS
#1. Como voce poderia usar arrange() para classificar todos os valores faltantes no começo? (dica: use is.na())

arrange(flights, desc(is.na(dep_time)), dep_time)

#2. Ordene flights para encontrar os voos mais atrasados. Encontre os voos que sairam mais cedo.

arrange(flights, desc(dep_delay))
arrange(flights, dep_delay)

#3. Ordene flights para encontrar os voos mais rapidos.

fastest_flights <- mutate(flights, mph = distance / air_time * 60)
fastest_flights <- select(
  fastest_flights, mph, distance, air_time,
  flight, origin, dest, year, month, day
)

head(arrange(fastest_flights, desc(mph)))

#4. Quais voos viajaram por mais tempo? Quais viajaram por menos tempo?

arrange(flights, desc(air_time))
arrange(flights, air_time)




#### Selecionando linhas com select()
select(flights, year, month, day)

select(flights, year:day) #seleciona todas as colunas entre year e day (contendo year e day)
select(flights, -(year:day)) #todas exceto as que vao de year ate day

rename(flights, tail_num = tailnum)

select(flights, time_hour, air_time, everything())



#### Exercicios
#1. Maior numero possivel de modos diferentes de selecionar dep_time, dep_delay, arr_time e arr_delay

select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, "dep_time", "dep_delay", "arr_time", "arr_delay")
select(flights, 4, 6, 7, 9)

#maneira melhor
select(flights, one_of(c("dep_time", "dep_delay", "arr_time", "arr_delay")))

variables <- c("dep_time", "dep_delay", "arr_time", "arr_delay")
select(flights, one_of(variables))

select(flights, starts_with("dep_"), starts_with("arr_"))

select(flights, matches("^(dep|arr)_(time|delay)$"))

#2. O que acontece ao incluir o nome de uma variável várias vezes
#em uma chamada de select()?
select(flights, year, month, day, year, year)

#R: apenas na primeira ocorrencia aparece, as repetições sao
# ignoradas
# o legal é que da pra usar select() combinado a everything()
# pra ordenar colunas sem ter que especificar todas elas

select(flights, arr_delay, everything())

#3. O que a função one_of() faz? pq é util nesse caso (no vetor abaixo)?

vars <- c("year", "month", "day", "dep_delay", "arr_delay")

select(flights, one_of(vars))
#R: seleciona variaveis com um vetor de caracteres
# em vez de argumentos sem aspas. a função é util pq
# é mais facil gerar vetores de char com nomes de variaveis
# do que gerar nomes de variaveis sem aspas

select(flights, vars) #so funciona direito se vars conter
#nomes de colunas (se nao for coluna, select vai substituir
# com os valores de vars e selecionar essas colunas)
select(flights, !!!vars) #forma de nao conflitar

#4. 

select(flights, contains("TIME"))
select(flights, contains("TIME", ignore.case = FALSE))



######## adicionar novas variaveis com mutate()

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, air_time
                      )
mutate(flights_sml, 
       gain = arr_delay - dep_delay, 
       speed = distance / air_time * 60
       )

mutate(flights_sml, 
       gain = arr_delay - dep_delay, 
       hours = air_time / 60,
       gain_per_hour = gain / hours
       )

#mantendo apenas as novas variaveis com transmute()
transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
          )



#funcoes de criacao uteis

#operadores aritmeticos
#aritmetica modular
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
          )


#logaritmos
 #offsets
(x <- 1:10)
lag(x) # valores anteriores num vetor
lead(x) # valores seguintes num vetor

#agregados cumulativos e de rolagem
x
cumsum(x)
cummean(x)

#comparacoes logicas
#classificacao

y <- c(1, 2, 2, NA, 3, 4)
min_rank(y)
min_rank(desc(y))

row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

#EXERCICIOS
#1.

1504 %/% 100 #horas
1504 %% 100 #minutos


# 1 maneira
transmute(flights,
          dep_time,
          minute_dep_time = dep_time %/% 100 *60 + dep_time %% 100,
          sched_dep_time,
          minute_sched_dep_time = sched_dep_time %/% 100 *60 + sched_dep_time %% 100
)


# maneira mais correta

flights_times <- mutate(flights,
                        dep_time_mins = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
                        sched_dep_time_mins = (sched_dep_time %/% 100 * 60 +
                                                 sched_dep_time %% 100) %% 1440
                        )

select(
  flights_times, dep_time, dep_time_mins, sched_dep_time,
  sched_dep_time_mins
)


#usando a funcao pra simplificar

time2mins <- function(x) {
  (x %/% 100 * 60 + x %% 100) %% 1440
}

flights_times <- mutate(flights,
                        dep_time_mins = time2mins(dep_time),
                        sched_dep_time_mins = time2mins(sched_dep_time)
)

select(
  flights_times, dep_time, dep_time_mins, sched_dep_time,
  sched_dep_time_mins
)


#2. Compare air_time e arr_time - dep_time



transmute(flights,
          air_time,
          arr_time,
          dep_time,
          dif_time = (arr_time) - (dep_time),
          dif_time_mins = time2mins(dif_time)
)



#######

flights_airtime <-
  mutate(flights,
         dep_time = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
         arr_time = (arr_time %/% 100 * 60 + arr_time %% 100) %% 1440,
         air_time_diff = air_time - arr_time + dep_time
  )


nrow(filter(flights_airtime, air_time_diff != 0))
#logo há diferenças (nos dados é possivel ver que o air_time
#só corresponde ao tempo no ar mesmo, tirando tempo de aviao
# decolando e pousando, alem das time zones que podem afetar
#a conta com viagens que passam pela meia noite)


ggplot(flights_airtime, aes(x = air_time_diff)) +
  geom_histogram(binwidth = 1)


ggplot(filter(flights_airtime, dest == "LAX"), aes(x = air_time_diff)) +
  geom_histogram(binwidth = 1)


#3. compare dep_time, sched_dep_time e dep_delay

transmute(flights,
          dep_time,
          sched_dep_time,
          dep_delay
)

#############
flights_deptime <-
  mutate(flights,
         dep_time_min = (dep_time %/% 100 * 60 + dep_time %% 100) %% 1440,
         sched_dep_time_min = (sched_dep_time %/% 100 * 60 +
                                 sched_dep_time %% 100) %% 1440,
         dep_delay_diff = dep_delay - dep_time_min + sched_dep_time_min
  )

filter(flights_deptime, dep_delay_diff != 0)

ggplot(
  filter(flights_deptime, dep_delay_diff > 0),
  aes(y = sched_dep_time_min, x = dep_delay_diff)
) +
  geom_point()




#4. encontre os 10 voos mais atrasados

rankme <- tibble(
  x = c(10, 5, 1, 5, 5)
)

rankme <- mutate(rankme,
                 x_row_number = row_number(x),
                 x_min_rank = min_rank(x),
                 x_dense_rank = dense_rank(x)
)
arrange(rankme, x)

rankme$x_min_rank
rankme$x_dense_rank

flights_delayed <- mutate(flights,
                          dep_delay_min_rank = min_rank(desc(dep_delay)),
                          dep_delay_row_number = row_number(desc(dep_delay)),
                          dep_delay_dense_rank = dense_rank(desc(dep_delay))
)
flights_delayed <- filter(
  flights_delayed,
  !(dep_delay_min_rank > 10 | dep_delay_row_number > 10 |
      dep_delay_dense_rank > 10)
)
flights_delayed <- arrange(flights_delayed, dep_delay_min_rank)
print(select(
  flights_delayed, month, day, carrier, flight, dep_delay,
  dep_delay_min_rank, dep_delay_row_number, dep_delay_dense_rank
),
n = Inf
)









#5. o que 1:3 + 1:10 retorna? e pq?
1:3 + 1:10

# https://jrnold.github.io/r4ds-exercise-solutions/transform.html#exercise-5.5.5


#6. ?Trig

x <- seq(-3, 7, by = 1 / 2)
sin(pi * x)
cos(pi * x)
tan(pi * x)

sinpi(x)
cospi(x)
tanpi(x)

atan2(c(1, 0, -1, 0), c(0, 1, 0, -1)) #angulo entre o eixo x
#e o vetor de (0, 0) a (x, y)
t=seq(0,10,0.1)
y = sin(t)
z = cos(t)
w = tan(t)
plot(t, y, type = "l", ylab = "seno")
plot(t, z, type = "l", ylab = "cos")
plot(t, w, type = "l", ylab = "tan")


#usando ggplot
qplot(t,y,geom="path", xlab="time", ylab="Sine wave")





#### RESUMOS AGRUPADOS COM summarize()
#atraso medio
summarize(flights, delay = mean(dep_delay, na.rm = TRUE))



#atraso medio por data
by_da <- group_by(flights, year, month, day)
summarize(by_da, delay = mean(dep_delay, na.rm = TRUE))


#juntos, group_by() e summarize() serao muito usados
#quando trabalhando comn dplyr: resumos agrupados


#PIPE combinando varias operacoes

by_dest <- group_by(flights, dest) #agrupa voos por destino
delay <- summarize(by_dest, #resumo para calcular a distancia, atraso medio e numero de voos
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
                   )
delay <- filter(delay, count > 20, dest != "HNL") #filtra para remover os pontos ruidosos 
#e o aeroporto de honolulu que é quase duas vezes mais distante que o aeroporto mais proximo

#isso é chato, pois temos que dar um nome para cada data frame
#intermediario


ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)


#alternativa de codigo usando o pipe (%>%)

delays <- flights %>% #pega o data frame e agrupa
  group_by(dest) %>% #depois resume
  summarize(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  )%>% #depois filtra
  filter(count > 20, dest != "HNL")


#valores faltantes

flights %>% 
  group_by(year, month, day) %>% 
  summarize(mean = mean(dep_delay))

#ocorrem varios NAs sem o na.rm configurado
#todas as funcoes de agregacao tem um argumento na.rm

flights %>% 
  group_by(year, month, day) %>% 
  summarize(mean = mean(dep_delay, na.rm = TRUE))



not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarize(mean = mean(dep_delay))


#COUNTS recomendavel sempre que fizer qualquer agregacao
#assim pode-se verificar se nao estamos tirando conclusoes
#com base em qtds muito pequenas de dados
#(n()) ou (sum(!is.na(x))) que sao os valores nao faltantes

#avioes (identificados pelo numero de cauda) que tem maiores
#atrasos medios

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarize(
    delay = mean(arr_delay)
  )

ggplot(data = delays, mapping = aes(x = delay)) +
  geom_freqpoly(binwidth = 10)


#diagrama de dispersao do numero de voos versus atraso medio
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )


ggplot(data = delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)


#é possivel ver que quando ha menos voos ha uma variacao maior no atraso medio
#sempre que fizer o grafico de uma media (ou outro resumo/summary) versus
#tamanho do grupo, vera que a variacao diminui a medida que o tamanho
#amostral aumenta


#é importante filtrar os grupos com menores numeros de
#observacoes, para que voce possa ver mais do padrao e
#menos da variacao extrema no menores grupos
#isso que o codigo a seguir faz, e ainda mostra um padrao
#util para integrar ggplot2 em fluxos dplyr
delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

#o primeiro plot tem valores extremos em algumas poucas ocasioes
#o segundo retira esses valores a partir do filtro 

#usa o ctrl+ shift+ p pra modificar o n e rodar de novo
#o codigo sem precisar selecionar tudo de novo e dar ctrl+enter










#exemplo com batedores de beisebal usando o pacote Lahman
#acontece a mesma coisa, ha alguns casos extremos de batedores que tem 100% de rebatidas, mas que tiveram
#1 jogada apenas (ou muito poucas jogadas/tentativas).
#quando aumenta o numero de oportunidades, a media de rebatidas vai se aproximando entre eles (o agregado diminui
# a medida que obtemos mais pontos de dados)

#ha uma correlacao positiva entre habilidade(ba) e oportunidades de acertar a bola(ab). Isso pq os times controlam
#quem joga e, obviamente, eles escolhem os melhores jogadores



#converte para um tibble para que seja bem impresso
batting <- as_tibble(Lahman::Batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarize(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() +
  geom_smooth(se = FALSE)



#se vc classificar inocentemente sobre desc(ba), as pessoas com melhores medias de rebatidas serao claramente
#sortudas, não habilidosas (so tiveram uma oportunidade e rebateram)


batters %>% 
  arrange(desc(ba))


#FUNCOES UTEIS DE RESUMO
##medidas de localizacao

not_cancelled %>% 
  group_by(year, month, day) %>%
  summarize(
    # average delay:
    avg_delay1 = mean(arr_delay),
    # average positive delay:
    avg_delay2 = mean(arr_delay[arr_delay > 0])
  )

##medidas de dispersao

# Por que a distancia para alguns destinos é mais variavel
# do que outras?

not_cancelled %>% 
  group_by(dest) %>% 
  summarize(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))


##medidas de classificacao

#Quando o primeiro e o ultimo voos partiram a cada dia?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarize(
    first = min(dep_time),
    last = max(dep_time)
  )


##medidas de posicao
#primeiro e ultimo embarque de cada dia
not_cancelled %>%
  group_by(year, month, day) %>% 
  summarize(
    first_dep = first(dep_time),
    last_dep = last(dep_time)
  )

#
not_cancelled %>%
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))


##contagens
#voce viu n(), que nao recebe argumentos e retorna o tamanho do grupo atual.
#para contar o numero de valores nao faltantes, use sum(!is.na(x)).
#Para contar o numero de valores distintos (unicos), use n_distinct(x)

# Quais destinos tem mais transportadoras?
not_cancelled %>% 
  group_by(dest) %>% 
  summarize(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))


#funcao auxiliar simples fornecida por dplyr para contagem
not_cancelled %>% 
  count(dest)

#usando a funcao para contar (somar) o numero total de milhas que um aviao fez:
not_cancelled %>% 
  count(tailnum, wt = distance)

#contagens e proporcoes de valores logicos sum(x > 10), mean(y == 0)
#quantos voos partiram antes das 5h (normalmente indicam voos atrasados que aprtiram no dia anterior)
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarize(n_early = sum(dep_time < 500))

#qual proporcao de voos estao atrasados mais de 1h?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarize(hour_per = mean(arr_delay > 60))

##agrupando multiplas variaveis
daily <- group_by(flights, year, month, day)
(per_day <- summarize(daily, flights = n()))

(per_month <- summarize(per_day, flights = sum(flights)))

(per_year <- summarize(per_month, flights = sum(flights)))



##desagrupando

daily %>% 
  ungroup() %>%  # nao mais agrupado pela data
  summarize(flights = n()) # todos os voos




#### Exercicios
#1. 5 maneiras diferentes de avaliar as caracteristicas do atraso tipico de um grupo de voos
#o que e mais importante: atraso na chegada ou na partida?
delay_char <-
  flights %>%
  group_by(flight) %>%
  summarise(n = n(),
            fifteen_early = mean(arr_delay == -15, na.rm = T),
            fifteen_late = mean(arr_delay == 15, na.rm = T),
            ten_always = mean(arr_delay == 10, na.rm = T),
            thirty_early = mean(arr_delay == -30, na.rm = T),
            thirty_late = mean(arr_delay == 30, na.rm = T),
            percentage_on_time = mean(arr_delay == 0, na.rm = T),
            twohours = mean(arr_delay > 120, na.rm = T)) %>%
  map_if(is_double, round, 2) %>%
  as_tibble()
```

A flight is 15 minutes early 50% of the time, and 15 minutes late 50% of the time.

```{r}
delay_char %>%
  filter(fifteen_early == 0.5, fifteen_late == 0.5)
```

A flight is always 10 minutes late.

```{r}
delay_char %>%
  filter(ten_always == 1)
```

A flight is 30 minutes early 50% of the time, and 30 minutes late 50% of the time.

```{r}
delay_char %>%
  filter(thirty_early == 0.5 & thirty_late == 0.5)
```

99% of the time a flight is on time. 1% of the time it's 2 hours late.

```{r}
delay_char %>%
  filter(percentage_on_time == 0.99 & twohours == 0.01)

##o que essa pergunta tras e uma questao fundamental na analise de dados:
##a funcao de custo. Como analistas, a razao pela qual nos interessamos pelos
##atrasos nos voos é pq isso custa para os passageiros. Mas vale a pena
##pensar cuidadosamente sobre como isso e custoso e usar essa informação
##para rankear e mensurar esses cenarios.

##em varios cenarios, o atraso na chegada é mais imporante. Na maioria,
##chegar atrasado é mais custoso para o passageiro pelo fato de que acarreta
##numa disrupçao no proximos estagios da viagem dele, como as conexoes e
##e encontros agendados

##se o atraso for na partida sem afetar a hora da chegada, esse atraso nao vai
##afetar os planos nem o tempo total gasto na viagem. Esse atraso poderia
##ser ate benefico, se menos tempo for gasto dentro do proprio aviao,
##ou ate negativo, se esse horario atrasado continuar sendo gasto quando o
##aviao ainda na pista

##variacao na hora da chegada é pior do que consistencia. Se um voo esta
##sempre 30 mins atrasado e esse atraso é conhecido, entao é como se a hora
##de chegada levasse em conta esse tempo (o atraso ja pode fazer parte do 
##horario estabelecido). O viajante poderia facilmente se planejar para isso.
##mas quanto maior a variacao nos tempos de voo, mais dificil fica se planejar

#2. crie outra abordagem que lhe dara o mesmo resultado que not_cancelled %>% count(dest)
#not_cancelled %>% count(tailnum, wt = distance) (sem usar count())
#com count
not_cancelled %>% 
  count(dest)
#sem count
not_cancelled %>%
  group_by(dest) %>%
  summarize(n = length(dest))
#ou
not_cancelled %>%
  group_by(dest) %>%
  summarise(n = n())
#ou
not_cancelled %>%
  group_by(tailnum) %>%
  tally()

#com count
not_cancelled %>% 
  count(tailnum, wt = distance)
#sem count
not_cancelled %>%
  group_by(tailnum) %>%
  summarize(n = sum(distance))
#ou
not_cancelled %>%
  group_by(tailnum) %>%
  tally(distance)

#3. nossa definicao de voos cancelados (is.na(dep_delay) | is.na(arr_delay)) e ligeiramente
#insuficiente. Pq? Qual a coluna mais importante?

filter(flights, !is.na(dep_delay), is.na(arr_delay)) %>% 
  select(dep_time, arr_time, sched_arr_time, dep_delay, arr_delay)

## se um voo nunca parte, entao nao pousa. Um voo poderia tambem partir e nao pousar se ele cair, ou se for
##redirecionado e pousar num aeroporto diferente do destino inicial. Entao a coluna mais importante é a 
## arr_delay, que indica a quantidade de atraso na chegada (pouso)

#4. veja o numero de voos cancelados por dia. Existe um padrao? A proporcao de voos cancelados esta 
#relacionada ao atraso medio?

##(is.na(arr_delay) & is.na(dep_delay)) is equal to !is.na(arr_delay) | !is.na(dep_delay)

cancelled_per_day <-
  flights %>%
  mutate(cancelled = (is.na(arr_delay) | is.na(dep_delay))) %>%
  group_by(year, month, day) %>%
  summarise(
    cancelled_num = sum(cancelled),
    flights_num = n(),
  )

##plot 
ggplot(cancelled_per_day) +
  geom_point(aes(x = flights_num, y = cancelled_num))

## plotando o numero de voos contra o numero de voos cancelados é possivel  ver que
## o numero de voos cancelados aumenta a medida que o numero de voos aumenta (em um dia)


##agora a ideia foi ver se ha uma relacao entre a proporcao de voos cancelados e a media
## de atraso por dia(tanto na partida quanto na chegada)

cancelled_and_delays <-
  flights %>%
  mutate(cancelled = (is.na(arr_delay) | is.na(dep_delay))) %>%
  group_by(year, month, day) %>%
  summarise(
    cancelled_prop = mean(cancelled),
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    avg_arr_delay = mean(arr_delay, na.rm = TRUE)
  ) %>%
  ungroup()

#plot voos cancelados x media de atraso na partida por dia
ggplot(cancelled_and_delays) +
  geom_point(aes(x = avg_dep_delay, y = cancelled_prop)) 

cor(x = cancelled_and_delays$avg_dep_delay , y = cancelled_and_delays$cancelled_prop, method =  "pearson")
#com a reta  
ggplot(cancelled_and_delays, aes(x = avg_dep_delay, y = cancelled_prop)) +
  geom_point() +
  geom_smooth(method=lm, se=FALSE)


#plot voos cancelados x media de atraso na chegada por dia
ggplot(cancelled_and_delays) +
  geom_point(aes(x = avg_arr_delay, y = cancelled_prop))

cor(x = cancelled_and_delays$avg_arr_delay , y = cancelled_and_delays$cancelled_prop, method =  "pearson")
## da pra ver que sim, ha correlacao

#5 Qual companhia tem os piores atrasos? Desafio: voce consegue desembaralhar os efeitos dos
#aeroportos ruins versus companhias ruins? Pq/pq n? (dica: pense em
#flights %>% group_by(carrier, dest) %>%  summarize(n()))

flights %>% #como foi visto na #3, a coluna arr_delay é a mais importante para saber qual a pior companhia
  group_by(carrier) %>%
  summarize(arr_delay = mean(arr_delay, na.rm = TRUE)) %>%  
  arrange(desc(arr_delay))

##qual a companhia f9?
filter(airlines, carrier == "F9")

##

flights %>%
  filter(!is.na(arr_delay)) %>%
  # Total delay by carrier within each origin, dest
  group_by(origin, dest, carrier) %>%
  summarise(
    arr_delay = sum(arr_delay),
    flights = n()
  ) %>%
  # Total delay within each origin dest
  group_by(origin, dest) %>%
  mutate(
    arr_delay_total = sum(arr_delay),
    flights_total = sum(flights)
  ) %>%
  # average delay of each carrier - average delay of other carriers
  ungroup() %>%
  mutate(
    arr_delay_others = (arr_delay_total - arr_delay) /
      (flights_total - flights),
    arr_delay_mean = arr_delay / flights,
    arr_delay_diff = arr_delay_mean - arr_delay_others
  ) %>%
  # remove NaN values (when there is only one carrier)
  filter(is.finite(arr_delay_diff)) %>%
  # average over all airports it flies to
  group_by(carrier) %>%
  summarise(arr_delay_diff = mean(arr_delay_diff)) %>%
  arrange(desc(arr_delay_diff))



#6. para cada aviao, conte o numero de voos antes do primeiro atraso de mais de uma hora


flights %>%
  mutate(dep_date = time_hour) %>%
  group_by(tailnum) %>%
  arrange(dep_date) %>%
  mutate(cumulative = !cumany(arr_delay > 60)) %>%
  filter(cumulative == T) %>%
  tally(sort = TRUE)

##ou
flights %>%
  group_by(tailnum) %>%
  arrange(time_hour) %>%
  mutate(cum = arr_delay > 60,
         cum_any = cumsum(cum)) %>%
  filter(cum_any < 1) %>%
  tally(sort = TRUE) #ou count



#
flights %>%
  group_by(tailnum) %>%
  arrange(time_hour) %>%
  mutate(cum = arr_delay > 60,
         cum_any = cumsum(cum)) %>%
  filter(cum_any < 1) %>%
  count(sort = TRUE) #conta na ordem decrescente se for TRUE

#7. o que o argumento sort faz no count()?
###conta na ordem decrescente (na ordem de n) se for TRUE. voce poderia usar isso
###a qualquer hora que usasse count() seguido de arrange()



#Mudancas agrupadas (e filtros)

##encontre os piores membros de cada grupo:
flights_sml %>% 
  group_by(year, month, day) %>% 
  filter(rank(desc(arr_delay))< 10) #ate o rank 10 seguindo em ordem decrescente o arr_delay (ou seja, os 10 piores)

##encontre todos os grupos maiores do que um limiar:
popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 365)
popular_dests

##padronize para calcular metricas de grupo:
popular_dests %>% 
  filter(arr_delay > 0) %>% 
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
  select(year:day, dest, arr_delay, prop_delay)

#um filtro agrupado é uma mudança agrupada seguida por um filtro nao agrupado. 
#geralmente é bom evitar (exceto para manipulaçoes rapidas: fica dificil verificar
#se foi feita uma manipulacao corretamente).

#window functions
vignette("window-functions")

library(Lahman)

batting <- Lahman::Batting %>%
  as_tibble() %>%
  select(playerID, yearID, teamID, G, AB:H) %>%
  arrange(playerID, yearID, teamID) %>%
  semi_join(Lahman::AwardsPlayers, by = "playerID")

players <- batting %>% group_by(playerID)


# For each player, find the two years with most hits
filter(players, min_rank(desc(H)) <= 2 & H > 0)
# Within each player, rank each year by the number of games played
mutate(players, G_rank = min_rank(G))

# For each player, find every year that was better than the previous year
filter(players, G > lag(G))
# For each player, compute avg change in games played per year
mutate(players, G_change = (G - lag(G)) / (yearID - lag(yearID)))

# For each player, find all where they played more games than average
filter(players, G > mean(G))
# For each, player compute a z score based on number of games played
mutate(players, G_z = (G - mean(G)) / sd(G))


#types of window functions
##ranking functions

x <- c(1, 1, 2, 2, 2)

row_number(x)
#> [1] 1 2 3 4 5
min_rank(x)
#> [1] 1 1 3 3 3
dense_rank(x)
#> [1] 1 1 2 2 2

cume_dist(x)
#> [1] 0.4 0.4 1.0 1.0 1.0
percent_rank(x)
#> [1] 0.0 0.0 0.5 0.5 0.5

#the top 10% of records withn each group
filter(players, cume_dist(desc(G)) < 0.1)


by_team_player <- group_by(batting, teamID, playerID)
by_team <- summarise(by_team_player, G = sum(G))
by_team_quartile <- group_by(by_team, quartile = ntile(G, 4))
summarise(by_team_quartile, mean(G))


#Lead and lag

x <- 1:5
lead(x)
#> [1]  2  3  4  5 NA
lag(x)
#> [1] NA  1  2  3  4


#podem ser usados para:
#computar diferenças ou mudanças percentuais
# Compute the relative change in games played
mutate(players, G_delta = G - lag(G))

# Find when a player changed teams
filter(players, teamID != lag(teamID))



#EXERCICIOS
#1. Volte a tabela de funcoes de mudanca e filtragem uteis.Descreva como cada operacao muda quando voce as combina
#com o agrupamento.

##funcoes de resumo ( mean() ), offset/deslocamento ( lead(), lag() ), funcoes de ranking/classificacao
## ( min_rank(), row_number() ), operam em cada grupo quando usadas com group_by() em mutate() ou filter().
##operadores aritmeticos ( +, - ), operadores logicos ( <, == ), operadores aritmeticos modulares ( %%, %/% ),
##funcoes logaritmicas ( log ) nao sao afetadas pelo group_by.

##funcoes de resumo como mean(), median(), sum(), std() e outras
## que foram abordadas no topico 'funcoes de resumo uteis' calculam
## seus valores em cada grupo quando usadas com mutate(), filter() e group_by().
tibble(
  x = 1:9, #fez uma coluna x com o vetor de 1 a 9
  group = rep(c("a", "b", "c"), each = 3) #fez uma coluna group com um vetor de a, b e c repetidos em 3
) %>%        #passou pra dentro do mutate()
  mutate(x_mean = mean(x)) %>% #passou pra dentro do group_by() e fez uma coluna nova no tibble chamada x_mean, com a media de x (da soma dos valores no vetor)
  group_by(group) %>% #passou pra dentro do mutate() (agrupou baseado na coluna group(o vetor com 3x a,b e c))
  mutate(x_mean_2 = mean(x)) #fez uma nova coluna chamada x_mean_2, com as medias que foram agrupadas anteriormente (dos grupos a, b e c)

##operadores aritmeticos nao sao afetados pelo group_by().
tibble(
  x = 1:9, #mesma coisa
  group = rep(c("a", "b", "c"), each = 3) #mesma coisa
) %>% #passou tudo pra dentro do mutate()
  mutate(y = x + 2) %>% #adicionou uma coluna chamada y com o resultado da soma e passou pro group_by()
  group_by(group) %>% #agrupou baseado na coluna group e passou tudo pro mutate
  mutate(z = x + 2) #criou uma nova coluna z com a soma, mas o resultado nao mudou

##os operadores aritmeticos modulares %/% e %% nao sao afetados
##pelo group_by().
tibble(
  x = 1:9,
  group = rep(c("a", "b", "c"), each = 3)
) %>%
  mutate(y = x %% 2) %>%
  group_by(group) %>%
  mutate(z = x %% 2) #td a mesma coisa

##uncoes logaritmas log(), log2(), log10() nao sao afetadas pelo
##group_by()
tibble(
  x = 1:9,
  group = rep(c("a", "b", "c"), each = 3)
) %>%
  mutate(y = log(x)) %>%
  group_by(group) %>%
  mutate(z = log(x)) #td a mesma coisa

##as funcoes de deslocamento lead() e lag() respeitam os agrupamentos
##em group_by(). As funcoes lag() e lead() vao somente retornar valores
##para cada grupo.
tibble(
  x = 1:9,
  group = rep(c("a", "b", "c"), each = 3)
) %>%
  group_by(group) %>%
  mutate(
    lag_x = lag(x), #criou uma coluna com o valor anterior de x
    lead_x = lead(x) #criou uma coluna com o valor posterior a x
  ) #o 3 e o 6 nao sao mostrados em lag_x pq pertencem a outro grupo
    #o 4 e o 7 tambem nao sao mostrados em lead_x pq sao de outro grupo
    #o 0 nao é mostrado em lag_x pq nao existe, pelo mesmo motivo o 10
    #nao é mostrado em lead_x

##as funcoes agregadoras cumulativas e de rolagem cumsum(), cummin(),
##cunmax() e cunmean() calculam valores para cada grupo.
tibble(
  x = 1:9,
  group = rep(c("a", "b", "c"), each = 3)
) %>%
  mutate(x_cumsum = cumsum(x)) %>% #ta somando os valores do vetor a cada posicao e passa pra dentro do group_by()
  group_by(group) %>% #agrupou baseado na coluna group e passou pro mutate()
  mutate(x_cumsum_2 = cumsum(x)) #criou nova coluna x_cumsum_2, mas os valores sao calculados pra cada grupo separado

##comparadores logicos, <=, <, >, =>, != e == nao sao afetados pelo group_by().
tibble(
  x = 1:9,
  y = 9:1,
  group = rep(c("a", "b", "c"), each = 3)
) %>%
  mutate(x_lte_y = x <= y) %>%
  group_by(group) %>%
  mutate(x_lte_y_2 = x <= y) #td a mesma coisa dos casos que nao sao afetados

##funcoes de ordenacao/ranking como min_rank() funcionam com cada grupo
##quando usadas com group_by().
tibble(
  x = 1:9,
  group = rep(c("a", "b", "c"), each = 3)
) %>%
  mutate(rnk = min_rank(x)) %>%
  group_by(group) %>%
  mutate(rnk2 = min_rank(x)) #ordenou em 1, 2 e 3 pra cada grupo na nova coluna criada rnk2

##mesmo que nao tenha sido pedido na questao, note que arrange() ignora grupos
##quando classifica valores.
tibble(
  x = runif(9),
  group = rep(c("a", "b", "c"), each = 3)
) %>%
  group_by(group) %>%
  arrange(x)

##entretanto, a ordem dos valores do arrange() podem interagir com grupos
##quando usados com funcoes que dependem da ordem dos elementos, como lead(),
##lag(), ou cumsum().
tibble(
  group = rep(c("a", "b", "c"), each = 3),
  x = runif(9)
) %>%
  group_by(group) %>%
  arrange(x) %>%
  mutate(lag_x = lag(x))

#2. qual aviao (tailnum) tem o pior registro de pontualidade?

##é preciso considerar:
## 1. proporcao de voos cancelados e sem atraso e
## 2. media de atraso na chegada

##a primeira metrica é a proporcao entre voos nao cancelados e a pontualidade.
##a presenca de um atraso na chegada é usada pra concluir/considerar os voos nao cancelados.
##entretanto, ha varios avioes que nunca foram pontuais. Muitos desses que tem as proporcoes 
##mais baixas voaram muito poucas vezes.
flights %>% 
  filter(!is.na(tailnum)) %>% 
  mutate(on_time = !is.na(arr_time) & (arr_delay <= 0)) %>% 
  group_by(tailnum) %>% 
  summarize(on_time = mean(on_time), n = n()) %>% 
  filter(min_rank(on_time) == 1)

##entao emos que remover avioes com menos de 20 voos. A escolha dos 20 foi feita
##pq é proxima ao numero do primeiro quartil de voos feitos pelos avioes
quantile(count(flights, tailnum)$n)

##o aviao com pelo menos 20 voos com o pior registro de pontualidade foi:
flights %>%
  filter(!is.na(tailnum)) %>%
  mutate(on_time = !is.na(arr_time) & (arr_delay <= 0)) %>%
  group_by(tailnum) %>%
  summarise(on_time = mean(on_time), n = n()) %>%
  filter(n >= 20) %>%
  filter(min_rank(on_time) == 1)

##a segunda metrica é a media de atraso em minutos. Como na metrica anterior, so consideraremos
##avioes com mais de 20 voos. Um aviao diferente teve a pior pontualidade quando medida
##pela media de atraso em minutos.
flights %>%
  group_by(tailnum) %>%
  summarise(arr_delay = mean(arr_delay), n = n()) %>%
  filter(n >= 20) %>%
  filter(min_rank(desc(arr_delay)) == 1)

#3. a que horas voce deveria voar se quiser evitar atrasos ao maximo?
##voos mais cedo tem menos atrasos (quanto mais cedo menos atraso esperado)
flights %>%
  group_by(hour) %>%
  summarise(arr_delay = mean(arr_delay, na.rm = TRUE)) %>%
  arrange(arr_delay)

#4. para cada destino calcule os minutos totais de atraso. Para cada voo, calcule
# a proporcao do atraso total para seu destino.
flights %>%
  filter(arr_delay > 0) %>% 
  group_by(dest) %>%  
  mutate(total_mins_delay = sum(arr_delay),
         prop_delay = arr_delay/total_mins_delay) %>% 
  select(dest, month, day, dep_time, carrier, flight, 
         arr_delay, total_mins_delay, prop_delay) %>% 
  arrange(dest, desc(prop_delay))

## usando a companhia aerea como parametro
flights %>%
  filter(arr_delay > 0) %>%
  group_by(dest, origin, carrier, flight) %>%
  summarise(arr_delay = sum(arr_delay)) %>%
  group_by(dest) %>%
  mutate(
    arr_delay_prop = arr_delay / sum(arr_delay)
  ) %>%
  arrange(dest, desc(arr_delay_prop)) %>%
  select(carrier, flight, origin, dest, arr_delay_prop)




##ou feito por mim
flights %>%
  filter(arr_delay > 0) %>% 
  group_by(dest) %>%  
  transmute(total_mins_delay = sum(arr_delay),
         prop_delay = arr_delay/total_mins_delay) %>% 
  arrange(dest, desc(prop_delay))





#5. relacione (correlacione) usando lag() o atraso de um voo com o atraso 
#de um voo imediatamente anterior

atrasos_imediatamente_anteriores <- flights %>% 
  arrange(origin, month, day, dep_time) %>% 
  group_by(origin) %>% 
  mutate(dep_delay_lag = lag(dep_delay)) %>% 
  filter(!is.na(dep_delay), !is.na(dep_delay_lag))

atrasos_imediatamente_anteriores %>%
  group_by(dep_delay_lag) %>%
  summarise(dep_delay_mean = mean(dep_delay)) %>%
  ggplot(aes(y = dep_delay_mean, x = dep_delay_lag)) +
  geom_point() +
  scale_x_continuous(breaks = seq(0, 1500, by = 120)) +
  labs(y = "Departure Delay", x = "Previous Departure Delay")



atrasos_imediatamente_anteriores %>%
  group_by(origin, dep_delay_lag) %>%
  summarise(dep_delay_mean = mean(dep_delay)) %>%
  ggplot(aes(y = dep_delay_mean, x = dep_delay_lag)) +
  geom_point() +
  facet_wrap(~origin, ncol = 1) +
  labs(y = "Departure Delay", x = "Previous Departure Delay")




#6. veja cada destino. voce consegue encontrar os voos que sao suspeitamente rapidos? (provavel erro de entrada)
#calcule o tempo de viagem de um voo relativo ao voo mais curto para aquele destino. quais voos ficaram mais atrasados no ar?



#7. encontre todos os destinos que sao feitos por pelo menos duas companhias. use essa informacao para classificar as companhias.
flights %>% 
  group_by(dest) %>% 
  mutate(n_carriers = n_distinct(carrier)) %>% 
  filter(n_carriers > 1) %>% 
  group_by(carrier) %>% 
  summarize(n_dest = n_distinct(dest)) %>% 
  arrange(desc(n_dest)) 
  
filter(airlines, carrier == "EV")

filter(airlines, carrier %in% c("AS", "F9", "HA"))
