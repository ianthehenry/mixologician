# mixologic

Pronounce it with the stress on the second syllable, like "mixologist." Don't pronounce it like "mix-o-logic." That sounds awful.

This is the code accompanying an as-yet-unpublished blog post. That I haven't even finished writing yet. So you're really snooping around, huh?

# show me

Given the contents of my bar:

```shell-session
$ cat facts/bar
brandy
dry vermouth
lemon
light rum
lime
orange liqueur
reposado tequila
sugar
```

And my cocktail recipe book:

```shell-session
$ head facts/recipes
martini <- london dry gin
martini <- dry vermouth
daiquiri <- light rum
daiquiri <- lime juice
daiquiri <- simple syrup
margarita <- blanco tequila or reposado tequila
margarita <- lime juice
margarita <- orange liqueur
margarita <- lime wedge
...
```

What cocktails can I mix?

```shell-session
$ cat results/mixable
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
cognac -> between-the-sheets
sherry -> sherry-cobbler
rhum agricole -> ti-punch
```

Well that'll make things a bit more interesting.

# this seems dumb

No you're wrong it's smart. Take a closer look at that daiquiri: the recipe calls for lime juice, but we don't have lime juice in our bar. We only have lime. So why does it show up as mixable?

Well, because it knows some rules. It knows that limes make lime juice (and lime wedge, and lime peel...). It even knows that lime plus sugar makes lime cordial -- so it knows that we're only one ingredient away from being able to make [a gimlet](https://www.tuxedono2.com/gimlet-cocktail-recipe), even though we don't *technically* have a single ingredient that the drink calls for.

# dependencies

- [Install Nix](https://nixos.org/guides/install-nix.html)
- Run `nix-shell`

# let me try

From within `nix-shell`:

    $ souffle mixologic.dl -F facts -D results

That will create two files, `results/mixable` and `results/shopping-list`. The recipes in `mixable` are all the drinks you have the ingredients to make. `shopping-list` lists ingredients that will allow you to make new drinks.

`shopping-list` only looks for recipes that you are *one ingredient* away from being able to make. So you might not get results, if you have a very sparse (or very comprehensive) bar. You might need to buy two new things to be able to make a new drink, and it won't tell you that.

# what else can i do

Customize the contents of your bar by editing `facts/bar`.

Customize your recipe book by editing `facts/recipes`. If you change recipes, you should probably re-run `./generate-auto-facts`. It's not strictly necessary, but it will make your output better.

`./generate-auto-facts` will overwrite the `facts/auto-*` files, so you shouldn't make changes to those.

You can also change the generation rules in `facts/begets`, or filter things out of your `shopping-list` by adding them to `facts/unbuyable`.

If you have a complicated ingredient production rule, like a multi-ingredient syrup, you have to change `mixologic.dl`.

# it seems hard to write down everything i have

Yeah. I recommend starting with the universe of all possible ingredients, by running `./list-ingredients`, and just removing anything you don't have.

You don't need to worry about ingredients like simple syrup or lime juice -- you can just write that you have lime, or just write that you have sugar. Unless you bought one of those little green bottles of lime juice. Then you should just write lime juice. You get it. Be honest, in this most of all.

# testing

From within `nix-shell`:

    $ cram test.t --shell=$SHELL -i

To run the tests.
