library(tidyverse)
table1
table2
table3
table4a
table4b

table1 %>% 
  mutate(rate = cases / population * 10000) #casos para cada 10mil habitantes

table1 %>% 
  count(year, wt = cases) #casos por ano

table1 %>% 
  ggplot(aes(year, cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country)) #mudanças durante o tempo


#exercicios
#2.
##tabelas separadas pra casos e populacao:
t2_cases <- filter(table2, type == "cases") %>% 
  rename(cases = count) %>% 
  arrange(country, year)

t2_population <- filter(table2, type == "population") %>% 
  rename(population = count) %>% 
  arrange(country, year)

## novo data frame com as colunas de casos e populacao e o calculo dos casos
## para cada 10k habitantes (rate):
t2_rate <- tibble(
  year = t2_cases$year,
  country = t2_cases$country,
  cases = t2_cases$cases,
  population = t2_population$population
) %>% 
  mutate(rate = (cases/population) * 10000) %>% 
  select(country, year, rate)

##
t2_rate <- t2_rate %>% 
  mutate(type = "rate") %>% 
  rename(count = rate)
##
bind_rows(table2, t2_rate) %>% 
  arrange(country, year, type, count)

##usando table 4a + 4b:
table4ab <- tibble(
  country = table4a$country,
  `1999` = table4a[["1999"]]/table4b[["1999"]] * 10000,
  `2000` = table4a[["2000"]]/table4b[["2000"]] * 10000
)
table4ab

#"The ideal format of a data frame to answer this question is one with columns country, 
#year, cases, and population. Then problem could be answered with a single mutate() call."


#3.
table2 %>% 
  filter(type == "cases") %>% 
  ggplot(aes(year, count)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country)) +
  scale_x_continuous(breaks = unique(table2$year)) +
  ylab("cases")

#Espalhando e reunindo
##uma variavel pode estar espalhada por varias colunas
##ou uma observacao pode estar espalhada por varias linhas

##a tabela 4a tem as colunas 1999 e 2000, que na verdade representam valores da variavel year, cada linha
##representa duas observacoes e nao uma.
table4a
#usamos gather()
table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")

table4b
table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")

tidy4a <- table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")
left_join(tidy4a, tidy4b) #juntado as duas ja tidy

##espalhando
table2
spread(table2, key = type, value = count)

#exercicios
#1.
stocks <- tibble(
  year = c(2015, 2015, 2016, 2016),
  half = c( 1, 2, 1, 2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>% 
  spread(year, return) %>% 
  gather("year", "return", `2015`:`2016`)


stocks %>% 
  spread(year, return)

##usando convert
stocks %>%
  spread(key = "year", value = "return") %>%
  gather(`2015`:`2016`, key = "year", value = "return", convert = TRUE)

#2. pq esse codigo falha?
table4a %>% 
  gather(1999, 2000, key = "year", value = "cases") #ele tenta selecionar as colunas de numero 1999 e 2000

table4a %>%
  gather("1999", "2000", key = "year", value = "cases")
table4a %>%
  gather(`1999`, `2000`, key = "year", value = "cases")

#3.pq spreadar nao da certo?
people <- tribble(
  ~name,             ~key,      ~value,
  #-----------------/-----------/-----
  "Phillip Woods",    "age",        45,
  "Phillip Woods",    "height",    186,
  "Phillip Woods",    "age",        50,
  "Jessica Cordero",  "age",        37,
  "Jessica Cordero",  "height",    156
)
glimpse(people)

spread(people, key, value)

people2 <- people %>%
  group_by(name, key) %>%
  mutate(obs = row_number())
people2

spread(people2, key, value)

#ou
people %>%
  distinct(name, key, .keep_all = TRUE) %>%
  spread(key, value)


#4. 
preg <- tribble(
  ~pregnant,   ~male, ~female,
  "yes",          NA,      10,
  "no",           20,      12
)

preg_tidy <- preg %>% 
gather(male, female, key = "sex", value = "count")
preg_tidy

#tirando os NA
preg_tidy2 <- preg %>%
  gather(male, female, key = "sex", value = "count", na.rm = TRUE)
preg_tidy2

preg_tidy3 <- preg_tidy2 %>%
  mutate(
    female = sex == "female",
    pregnant = pregnant == "yes"
  ) %>%
  select(female, pregnant, count)
preg_tidy3


filter(preg_tidy2, sex == "female", pregnant == "no")
filter(preg_tidy3, female, !pregnant)


##separando e unindo
table3 #a coluna rate contem 2 variaveis
table3 %>% 
separate(rate, into = c("cases", "population"))

table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")

table3 %>% 
  separate(
    rate, 
    into = c("cases", "population"),
    sep = "/",
    convert = TRUE)

table3 %>% 
  separate(year, into = c("century", "year"), sep = 2)


##unir
table5 %>% 
  unite(new, century, year)

table5 %>% 
  unite(new, century, year, sep = "") #sem separador


#exercicios
#1.

tibble(x = c("a,b,c", ",d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), sep = ",", fill = "right")
tibble(x = c("a,b,c", ",d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), fill = "left")



tibble(x = c("a,b,c", ",d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = "drop")
tibble(x = c("a,b,c", ",d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra = "merge")


tibble(x = c("a,b,c", ",d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))
tibble(x = c("a,b,c", ",d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill = "left")
tibble(x = c("a,b,c", ",d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), extra = "merge")


#2.
table5 %>% 
  unite(new, century, year, sep = "", remove = FALSE)



table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/", remove = FALSE)
