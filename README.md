# mixologic

Pronounce it with the stress on the second syllable, like "mixology." Don't pronounce it like "mix-o-logic." That sounds awful.

This is the code accompanying an as-yet-unpublished blog post. That I haven't even finished writing yet. So you're really snooping around, huh?

# just tell me

Given the contents of my bar:

```shell-session
$ cat facts/bar
lime
sugar
lemon
reposado tequila
cointreau
dry vermouth
gin
cynar
```

And my cocktail recipe book:

```shell-session
$ head facts/recipes
18th-century <- batavia arrack
18th-century <- creme de cacao
18th-century <- sweet vermouth
18th-century <- lime juice
20th-century <- london dry gin
20th-century <- creme de cacao
20th-century <- lillet or cocchi americano
20th-century <- lemon juice
212 <- reposado tequila
212 <- aperol
```

What cocktails can I mix?

```shell-session
$ cat results/mixable
cynar-flip
margarita
```

Gosh, that's not very many drinks. What should I add to my bar to expand my options?

```shell-session
$ cat results/shopping-list
london dry gin -> gimlet
london dry gin -> martini
light rum -> daiquiri
cognac -> sidecar
bourbon -> gold-rush
bourbon -> whiskey-sour
brandy -> sidecar
sherry -> sherry-cobbler
old tom gin -> bees-knees
gold rum -> rum-flip
rhum agricole -> ti-punch
```

Aha. I'll be back in a bit.

# dependencies

- Install `nix`
- Run `nix-shell`

# how do i run it

From within `nix-shell`:

    $ souffle mixologic.dl -F facts

That will create two files, `mixable` and `shopping-list`. `mixable` are all the recipes you have the ingredients to make. `shopping-list` tells you what you should buy to be able to make new recipes.

You can also run it like this:

    $ mkdir results
    $ souffle mixologic.dl -D results -F facts

If you prefer to avoid making a mess of the current directory.

That's what I do. But you can't check empty directories into `git` so that's not the default.

# what else can i do

Customize the contents of your bar by editing `facts/bar`.

Customize your recipe book by editing `facts/recipes`. If you change recipes, you should probably re-run `./generate-auto-facts`. It's not strictly necessary, but it will make your output better.

This overwrites the `facts/auto-*` files, so don't make changes to those.

You can also change the generation rules in `facts/begets`, or filter things out of your shopping list by adding them to `facts/unbuyable`.

If you have a complicated ingredient production rule, like a multi-ingredient syrup, you have to change `mixologic.dl`.

# testing

From within `nix-shell`:

    $ cram test.t --shell=$SHELL -i

To run the tests.
