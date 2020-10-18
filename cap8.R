#importando dados com readr
library(tidyverse)
install.packages("webreadr") #uma das opcoes de leitura de arquivos


heights <- read_csv("C:/Users/PAGSIM/Documents/ADM/2019.2/ESTATISTICA/R/Arquivos de Apoio/data/heights.csv")

read_csv("a, b, c
         1, 2, 3
         4, 5, 6")

read_csv("a, b
         1, 2 
         4, 5")

View(heights)

#como pular linhas com metadados no topo do arquivo:
read_csv("The first line of metadata
         The second line of metadata
         x, y, z
         1, 2, 3", skip = 2)

read_csv("#A coment i want to skip
         x, y, z
         1, 2, 3", comment = "#")

#como nao tratar a primeira linha como cabecalho (arquivo sem nomes de colunas):
read_csv("1, 2, 3\n4, 5, 6", col_names = FALSE)

#ou passar um vetor de caracteres pra ser usado como os nomes das colunas:
read_csv("1, 2, 3\n4, 5, 6", col_names = c("x", "y", "z"))

#representa o valor usado para representar NAs:
read_csv("a, b, c\n1, 2,.", na = ".")

#exercicios
#1. qual funcao seria usada para ler um arquivo em que os campos sao separados por "|"
read_delim("a|b\n1.0|2.0", delim = "|")

#2. alem de file, skip e comment, quais outros argumentos sao comuns a read_csv() e read_tsv()?
#col_names
#col_types
#locale
#na
#quoted_na
#quote
#trim_ws
#n_max
#guess_max
#progress
#skip_empty_rows

#3.quais os argumentos mais importantes de read_fwf()?
#col_positions

#4.

read_delim("x, y\n1, 'a,b'", delim = ",", quote = "'")

#read_csv() agora tem o argumento quote
read_csv("x, y\n1, 'a,b'", quote = "'")


#5.
read_csv("a, b\n1, 2, 3\n4, 5, 6") #n de colunas incompativel
read_csv("a, b, c\n1, 2\n1, 2, 3, 4") #NA originado pela falta de um valor apos o \n
read_csv("a, b\n\"1")
read_csv("a, b\n1, 2\na, b")
read_csv("a;b\n1;3") # o problema é o ";" separando os valores. Deve-se usar read_csv2():
read_csv2("a;b\n1;3")



#Analisando um vetor
#funcoes parse_*() recebem um vetor de caracteres e devolvem um vetor mais especializado
str(parse_logical(c("TRUE", "FALSE", "NA")))
str(parse_integer(c("1", "2", "3")))
str(parse_date(c("2010-01-01", "1979-10-14")))

parse_integer(c("1", "231", ".", "456"), na = ".")

x <- parse_integer(c("123", "345", "abc", "123.45")) #analise falhou e foi dado um aviso pq tem um char no vetor e um ponto
x #as falhas estao como NAs na saida

#usando problems para obter o conjunto completo
problems(x)

##Numeros
parse_double("1.23")

parse_double("1,23", locale = locale(decimal_mark = ",")) #lidar com o problema do uso de "," ao inves do "." nos numeros

parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")
parse_number("Isso custa $123,45", locale = locale(decimal_mark = ",")) #combinando parse_number com o argumento locale

#parse_number ignora a marca de agrupamento
parse_number("$123,456,789")
parse_number("123.456.789", locale = locale(grouping_mark = "."))
parse_number("123'456'789", locale = locale(grouping_mark = "'"))

parse_number("R$123'456'789,45", locale = locale(grouping_mark = "'", decimal_mark = ",")) #tentar arrumar depois

#Strings
charToRaw("Hadley")

x1 <- "El Ni\xf1o was particulary bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xbf\x82\xcd"

parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))

#Fatores
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)

#datas, datas-horas e horas
parse_datetime("2020-02-17T2127")

parse_datetime("20200217")

parse_datetime("1979-10-14")
parse_datetime("1979-10-14T10:11:12.12345")
parse_datetime("1979-10-14T1010", locale = locale(tz = "")) # Your current time zone

parse_date("2010-10-01")

library(hms)
parse_time("01:10 am")
parse_time("20:10:01")



parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")


date_names_langs()
#"br"
br_locale <- locale(date_format = "%d/%m/%Y")
parse_date("17/03/2020", locale = br_locale)
#exercicios
#2.
locale(decimal_mark = ".", grouping_mark = ".")
locale(decimal_mark = ",")
locale(grouping_mark = ",")

#3.
locale()
parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

#4.
parse_date("02/01/2006")
au_locale <- locale(date_format = "%d/%m/%Y")
parse_date("02/01/2006", locale = au_locale)

#6.
readr::guess_encoding()
stringi::str_enc_detect()

#7.
d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014
t1 <- "1705"
t2 <- "11:15:10.12 PM"

parse_date(d1, "%B %d, %Y")
parse_date(d2, "%Y-%b-%d")
parse_date(d3, "%d-%b-%Y")
parse_date(d4, "%B %d (%Y)", "%B %d (%Y)")
parse_date(d5, "%m/%d/%y")


parse_time(t1, "%H%M")
parse_time(t2, "%H:%M:%OS %p")




#Analisando um arquivo
guess_parser("2010-10-01")
guess_parser("15:01")
guess_parser(c("TRUE", "FALSE"))
guess_parser(c("1", "5", "9"))
guess_parser(c("12,352,561"))

str(parse_guess("2010-10-10"))

challenge <- read_csv(readr_example("challenge.csv"))
problems(challenge)

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_integer(),
    y = col_character()
  )
)

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_character()
  )
)
tail(challenge) #as datas estao como caracteres

challenge <- read_csv(
  readr_example("challenge.csv"),
  col_types = cols(
    x = col_double(),
    y = col_date()
  )
)
tail(challenge) #agora estao como date

challenge2 <- read_csv(
  readr_example("challenge.csv"),
  guess_max = 1001
)
challenge2

challenge2 <- read_csv(readr_example("challenge.csv"),
                       col_types = cols(.default = col_character())
                       )

df <- tribble(
  ~x, ~y,
  "1", "1.21",
  "2", "2.32",
  "3", "4.56"
)
df

type_convert(df)


#Escrevendo em um arquivo
write_csv(challenge, "challenge.csv")
challenge

write_csv(challenge, "challenge-2.csv")
read_csv("challenge-2.csv")

#alternativa (suporta colunas-listas - cap20)
write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")

#outra alternativa
install.packages("feather")
library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")

#outros tipos de dados
haven #spss, stata e sas
readxl #.xls e .xlsx
DBI #permite executar consultas sql contra uma base de dados e retorna um dataframe