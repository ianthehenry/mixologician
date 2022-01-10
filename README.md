# mixologician

This is the code accompanying a blog post I wrote called [Drinking with Datalog](https://ianthehenry.com/posts/drinking-with-datalog/).

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

Well, because it knows some rules. It knows that limes make lime juice (and lime wedge, and lime zest...). It even knows that lime zest plus sugar makes lime cordial -- so it knows that we're only one ingredient away from being able to make a [Gimlet](https://www.tuxedono2.com/gimlet-cocktail-recipe), even though we don't *technically* have a single ingredient that the drink calls for.

# cool

It *is* cool. And you can read all about how it works, right here: [Drinking with Datalog](https://ianthehenry.com/posts/drinking-with-datalog/).

# dependencies

- [Install Nix](https://nixos.org/guides/install-nix.html)
- Run `nix-shell`

*Or:*

- [Install Soufflé](https://souffle-lang.github.io/install)

And if you want to run the tests:

- [Install Python](https://www.python.org/downloads/)
- [Install Cram](https://pypi.org/project/cram/)

# let me try

From within your `nix-shell`:

    $ souffle mixologician.dl -F facts -D results

That will create three files: `results/mixable`, `results/mixable-recipes`, and `results/shopping-list`. `mixable` basically exists for tests and demos; `mixable-recipes` is a much more useful output. `shopping-list` will tell you all the ingredients you can buy that will allow you to make new drinks.

`shopping-list` only looks for recipes that you are *one ingredient* away from being able to make. So you might not get results, if you have a very sparse (or very comprehensive) bar. You might need to buy two new things to be able to make a new drink, and it won't tell you that. I think it would be *possible* to modify it to handle multiple missing ingredients, but I didn't try to do that.

# what else can i do

Customize the contents of your bar by editing `facts/bar`.

Customize your recipe book by editing [`facts/recipes`](facts/recipes). If you change recipes, you should probably re-run [`./generate-auto-facts`](generate-auto-facts). It's not strictly necessary, but it will make your output better.

`./generate-auto-facts` will overwrite the `facts/auto-*` files, so you shouldn't make changes to those.

You can also change the generation rules in [`facts/begets`](facts/begets), or filter things out of your `shopping-list` by adding them to [`facts/unbuyable`](facts/unbuyable). You can add new two-ingredient combinations by editing [`facts/combinations`](facts/combinations). If you have a combination that requires more than two ingredients, it wouldn't be hard to extend the logic with a new relation.

# it seems hard to make a full inventory of my giant bar

Yeah. I recommend starting with the universe of all possible ingredients, by running [`./list-ingredients`](list-ingredients), and just removing anything that you don't have. It's easier than typing everything up, and you can be sure that you're using the same names for things that the recipes use.

Of course you can use whatever names you want -- you can be as specific as you want -- and just add rules to [`facts/begets`](facts/begets) that make them compatible with your recipe book. Do you have Cointreau and Grand Marnier in your bar? Do you have recipes that distinguish between them? Add 'em in, and write that they both beget orange liqueur.

Remember that you don't need to worry about ingredients like lime juice or simple syrup -- you can just write that you have lime, or just write that you have sugar. Unless you bought one of those little green bottles of lime juice. Then you should just write lime juice. You get it. Be honest, in this most of all.

# testing

From within `nix-shell`:

    $ cram test.t --shell=$SHELL -i

# where did all those recipes come from

I scraped them from [Tuxedo No. 2](https://tuxedono2.com), an excellent cocktail site that I highly recommend you explore.

The recipes are named after the paths to the cocktails on that site, so if you want to learn more about a cocktail, just go to `https://tuxedono2.com/$name-cocktail-recipe` (and buy them a drink while you're at it).
