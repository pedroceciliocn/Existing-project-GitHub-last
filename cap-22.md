cap 22
================
pedro
19/11/2020

### Rótulo

``` r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    title = paste(
      "Fuel efficiency generally increases with",
      "engine size"
    )
  )
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](cap-22_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

### mais informações adicionadas

``` r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    title = paste(
      "Fuel efficiency generally increases with",
      "engine size"
    ),
    subtitle = paste(
      "Two seaters (sport cars) are an exception",
      "because of their light weight"
    ),
    caption = paste(
      "Data from fueleconomy.gov"
    )
  )
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](cap-22_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

### mudando os títulos dos eixos

``` r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    colour = "Car type"
  )
```

    ## `geom_smooth()` using method = 'loess' and formula 'y ~ x'

![](cap-22_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

### usando equações matemáticas em vez de strings de texto

``` r
df <- tibble(
  x = runif(10),
  y = runif(10)
)
ggplot(df, aes(x, y)) +
  geom_point() +
  labs(
    x = quote(sum(x[i] ^ 2, i == 1, n)),
    y = quote(alpha + beta + frac(delta, theta))
  )
```

![](cap-22_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->
