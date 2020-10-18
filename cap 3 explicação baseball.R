#http://bit.ly/Bayesbbal


library(knitr)
opts_chunk$set(cache = TRUE, warning = FALSE, message = FALSE)
options(digits = 3)

theme_set(theme_bw())

d <- data.frame(Success = c(11, 82, 2, 0, 1203, 5),
                Total = c(104, 1351, 26, 40, 7592, 166))

kable(d)


library(dplyr)
library(tidyr)
library(Lahman)

career <- Batting %>%
  filter(AB > 0) %>%
  anti_join(Pitching, by = "playerID") %>%
  group_by(playerID) %>%
  summarize(H = sum(H), AB = sum(AB)) %>%
  mutate(average = H / AB)

# use names along with the player IDs
career <- Master %>%
  tbl_df() %>%
  select(playerID, nameFirst, nameLast) %>%
  unite(name, nameFirst, nameLast, sep = " ") %>%
  inner_join(career, by = "playerID") %>%
  select(-playerID)


#filtramos os jogadores
# "sumarizamos"/resumimos cada jogador atraves do
# seu historico de diversos anos (H sao as tacadas e
#AB as que foram rebatidas, e a media de rebatidas)
#tambem foram adicionados os nomes e sobrenomes, para
#que fossem usados ao inves dos identificadores(numeros)

career


#esses seriam teoricamente os melhores rebatedores
career %>%
  arrange(desc(average)) %>%
  head(5) %>%
  kable()

#mas voce ve que eles tiveram 1 ou 2 oportunidades somente
#ou seja, tiveram apenas sorte

#e os piores?
career %>%
  arrange(average) %>%
  head(5) %>%
  kable()

#sera que sao mesmo os piores, visto as oportunidades
#reduzidas que tiveram?

##a estimativa esta ruim. da pra fazer melhor!

#PASSO 1: Fazer uma estimativa previa de todos os seus dados
#dando uma olhada na distribuicao das medias de rebatidas

career %>%
  filter(AB >= 500) %>%
  ggplot(aes(average)) +
  geom_histogram(binwidth = .005)

#foram retirados os jogadores com menos de 500 tacadas
#o primeiro passo de uma estimativa empirica bayesiana é
#estimar uma previa beta usando esses dados. Para fazer
#a estimativa previa a partir dos dados analizados no momento
#nao é a tipico abordagem bayesiana em que normalmente voce
#decide com antecedencia sua previa. Há um debate sobre quando
#e onde usar metodos empiricos bayesianos, mas basicamente
#isso recai sobre quantas observacoes temos:
#se tivermos muitas, podemos ter uma boa estimativa.
#bayes empirico é uma aproximacao de metodos bayesianos mais 
#exatos - e com a quantidade de dados aqui nesse caso, teremos
#uma aproximacao muito boa

#baseado no histograma, parece apropriado usar a distribuicao beta
#X~Beta(a0,ß0)
#é necessario pegar a0 e ß0, os quais chamamos "hiperparametros"
#do nosso modelo. Existem muitos metodos no R para encaixar
#uma distribuicao de probabilidade nos dados. Usaremos a funcao
#fitdistr do MASS


# just like the graph, we have to filter for the players we actually
# have a decent estimate of
career_filtered <- career %>%
  filter(AB >= 500)

m <- MASS::fitdistr(career_filtered$average, dbeta,
                    start = list(shape1 = 1, shape2 = 10))

alpha0 <- m$estimate[1]
beta0 <- m$estimate[2]

#isso resulta num a0=78.661 e ß0=224.875. Como encaixa/se mostra/comporta 
#com os dados no grafico?

ggplot(career_filtered) +
  geom_histogram(aes(average, y = ..density..), binwidth = .005) +
  stat_function(fun = function(x) dbeta(x, alpha0, beta0), color = "red",
                size = 1) +
  xlab("Batting average")

#PASSO 2: Usar essa distribuicao como previa pra cada
#estimativa individual

#agora quando olhamos qualquer individuo pra
#estimar sua media de rebatidas, iremos comecar com
#nossa previa geral, e atualizar baseado nas evidencias
#individuais. O processo detalhado foi feito no link (post original da distribuicao beta)
#http://stats.stackexchange.com/questions/47771/what-is-the-intuition-behind-beta-distribution

#adiciona a0 ao numero de tentativas e a0 + ß0 ao total
#de rebatidas

#considerando por exemplo um batedor hipotetico que
#jogou 1000 vezes e acertou 300 rebatidas. Podemos
#estimar sua media de rebatidas com:
(300+a0)/(1000+a0+ß0)=(300+78.7)/(1000+78.7+224.9)=0.29

#e agora um batedor com somente 10 tentativas e que acertou
#4 rebatidas:

(4+a0)/(10+a0+ß0)=(4+78.7)/(10+78.7+224.9)=0.264

#percebe-se que mesmo 4/10 sendo maior que 300/1000, conseguimos
#descobrir que o batedor dos 300/1000 é melhor que o dos 4/10

#fazer o calculo para todos os batedores é simples:

career_eb <- career %>% 
  mutate(eb_estimate = (H + alpha0)/ (AB + alpha0 + beta0))

#RESULTADOS
#agora podemos perguntar: quem sao os melhores batedores
#por essa estimativa melhorada?

options(digits = 3)
career_eb %>%
  arrange(desc(eb_estimate)) %>%
  head(5) %>%
  kable()
options(digits = 1)

#e os piores?
options(digits = 3)
career_eb %>%
  arrange(eb_estimate) %>%
  head(5) %>%
  kable()
options(digits = 1)

#note que em cada um desses casos, o bayes empirico
#nao simplesmente pegou os batedores que tinham 1 ou 2
#rebatidas. Ele encontrou os jogadores que rebateram bem,
#ou mal, durante um longo periodo (carreira longa).
#Podenos usar essas estimativas empiricas de Bayes sem nos
#preocuparmos em acidentalmente deixar casos de 0/1 e 1/1
#arruinarem tudo.

#em suma, bora ver como o bayes empirico mudou as estimativas
#das medias dos batedores:

ggplot(career_eb, aes(average, eb_estimate, color = AB)) +
  geom_hline(yintercept = alpha0 / (alpha0 + beta0), color = "red", lty = 2) +
  geom_point() +
  geom_abline(color = "red") +
  scale_colour_gradient(trans = "log", breaks = 10 ^ (1:5)) +
  xlab("Batting average") +
  ylab("Empirical Bayes batting average")


#a linha vermelha pontilhada é a media geral de 0.259
# a diagonal mostra que os pontos que se aproximam dela são
#os que tem mais evidencias (os com mais jogadas/o azul mais claro)
#os mais distantes sao os com menor evidencia.
#por isso algumas vezes esse processo é chamado de encolhimento:
#nos movemos todas as nossas estimativas para a media. Quanto se movem
#as estimativas depende de quanto de evidencia temos: se tivermos
#pouca, movemos um monte, quando temos muita, movemos so um pouco.
#esse é o "encolhimento" em suma: discrepancias extraordinarias
#exigem evidencias extraordinarias.

#CONCLUSAO
#ha dois passos para uma estimativa empirica Bayes:
#1. Estimar a distribuicao geral dos seus dados
#2. usar essa distribuicao como sua previa para estimar
#cada uma das medias

#o passo 1 pode ser feio de uma vez, "offline" - analise
#todos os seus dados e venha com algumas estimativas da sua
#distribuicao geral.
#o passo 2 e feito para cada nova observacao que voce estiver
#considerando. Voce deve estar estimando o sucesso de um post ou
#uma publicidade, ou classificando o comportamento de um usuario
#em termos de qual comumente ele faz determinada escolha
#e pq nos estamos usando beta e binomial, considere quao facil
#esse segundo passo é. Tudo que fizemos foi adicionar um
#numero aos sucessos, e adicionar outro numero ao total.
#voce pode colocar isso no seu sistema de producao com uma
#linha unica de codigo que leva nanosegundos para rodar



#// We hired a Data Scientist to analyze our Big Data
#// and all we got was this lousy line of code.
float estimate = (successes + 78.7) / (total + 303.5);

#I bring this up to disprove the notion that statistical sophistication
#necessarily means dealing with complicated, burdensome algorithms. 
#This Bayesian approach is based on sound principles, but it’s still easy to implement. 
#Conversely, next time you think “I only have time to implement a dumb hack,” 
#remember that you can use methods like these: it’s a way to choose your fudge factor. 
#Some dumb hacks are better than others!
#But when anyone asks what you did, remember to call it 
#“empirical Bayesian shrinkage towards a Beta prior.” 
#We statisticians have to keep up appearances