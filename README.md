# mixologic

Pronounce it with the stress on the second syllable, like "mixology." Don't pronounce it like "mix-o-logic." That sounds awful.

This is the code accompanying an as-yet-unpublished blog post. That I haven't even finished writing yet. So you're really snooping around, huh?

# show me

Given the contents of my bar:

```shell-session
$ cat facts/bar
cognac
cointreau
dry vermouth
gin
lemon
light rum
lime
reposado tequila
sugar
```

And my cocktail recipe book:

```shell-session
$ head facts/recipes
margarita <- blanco tequila or reposado tequila
margarita <- lime juice
margarita <- orange liqueur
margarita <- lime wedge
martini <- london dry gin
martini <- dry vermouth
daiquiri <- light rum
daiquiri <- lime juice
daiquiri <- simple syrup
...
```

What cocktails can I mix?

```shell-session
$ cat results/mixable
between-the-sheets
daiquiri
margarita
sidecar
```

Gosh, that's not very many. What could I add to my bar to expand my options?

```shell-session
$ cat results/shopping-list
london dry gin -> gimlet
london dry gin -> martini
champagne -> airmail
angostura bitters -> alabazam
sherry -> sherry-cobbler
rhum agricole -> ti-punch
```

Well that'll make things a bit more interesting. I'll be back in a bit.

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
