Set up some helpers that we'll use.

  $ function runtest {
  >   # souffle's output is a little noisy; do some light post-processing
  >   # to make the tests easier to read
  >   souffle "$TESTDIR"/mixologician.dl
  >   if [[ -s mixable ]]; then
  >     echo 'mixable:' $(cat mixable)
  >   fi
  >   if [[ -s shopping-list ]]; then
  >     echo "shopping list:"
  >     cat shopping-list
  >   fi
  > }
  $ function empty_bar { cat /dev/null > bar; }
  $ function empty_recipe_book { cat /dev/null > recipes; }
  $ function buy {
  >   for ingredient in "$@"; do
  >     echo "$ingredient" >> bar;
  >   done
  > }
  $ function sell {
  >   # this function is... very fragile.
  >   # it will break if an ingredient contains a single quote.
  >   filter="grep -vF "
  >   for ingredient in "$@"; do
  >     filter=$filter"-e '$ingredient'"
  >   done
  >   # the eval is necessary to interpret the quotes correctly... look
  >   # no one is more upset about this than i am
  >   eval "$filter" bar > new_bar
  >   mv new_bar bar
  > }
  $ function set_bar { empty_bar; buy "$@"; }
  $ function add_recipe {
  >   drink=$1
  >   shift
  >   for ingredient in "$@"; do
  >     echo "$drink <- $ingredient" >> recipes
  >   done
  > }

Now let's create some empty files that need to exist but that aren't relevant
to us.

  $ cat /dev/null > auto-begets
  $ cat /dev/null > auto-unbuyable

And set up some basic rules:

  $ echo "lime zest" > unbuyable
  $ echo "lime -> lime juice" > begets
  $ echo "lime -> lime zest" >> begets
  $ echo "reposado tequila -> tequila" >> begets
  $ echo "blanco tequila -> tequila" >> begets
  $ echo "lime cordial, sugar, lime zest" > combinations

Let's start with the simplest thing we can: nothing in our bar, one trivial
recipe in our book.

  $ empty_bar
  $ add_recipe "shot of vodka" vodka
  $ runtest
  shopping list:
  vodka -> shot of vodka

Okay! Nothing is mixable, but we learn that if we buy vodka we can mix up a
delicious shot:

  $ buy vodka
  $ runtest
  mixable: shot of vodka

Great. Now let's try a real cocktail:

  $ empty_recipe_book
  $ add_recipe "vodka martini" vodka "dry vermouth"
  $ runtest
  shopping list:
  dry vermouth -> vodka martini

Okay. Since we already have vodka, all we need is dry vermouth. Let's buy it:

  $ buy "dry vermouth"
  $ runtest
  mixable: vodka martini

Now we can mix a martini, and there are no further things that we could buy.

Now let's make sure "subtyping" works.

  $ empty_bar
  $ add_recipe margarita tequila "lime juice" "orange liqueur"
  $ buy "lime juice"
  $ buy "orange liqueur"
  $ runtest
  shopping list:
  tequila -> margarita
  reposado tequila -> margarita
  blanco tequila -> margarita

Great. We can't make a margarita yet, but if we buy either generic or specific
tequila, we'll be able to.

  $ buy "reposado tequila"
  $ runtest
  mixable: margarita

Since we bought reposado tequila, there's no longer any reason to buy blanco
tequila (at least according to our recipe book), so it goes away.

Now let's test multi-ingredient syrups.

  $ empty_bar
  $ add_recipe gimlet gin "lime juice" "lime cordial"
  $ buy gin
  $ buy "lime juice"

In order to make lime cordial, I need both limes and sugar. My lime *juice*
won't do, because I need the zest. That's two new ingredients, so neither will
show up on my shopping list.

  $ runtest
  shopping list:
  lime cordial -> gimlet

But it does tell me that I can just buy lime cordial directly (if, you know, I
could find it in a store).

But once I buy sugar...

  $ buy sugar
  $ runtest
  shopping list:
  lime cordial -> gimlet
  lime -> gimlet

It lets me know that I could either buy lime cordial directly, or I could just
buy limes.

In fact, now that I have sugar, I can get rid of my lime juice, because all I'll
need to make a gimlet is lime.

  $ sell "lime juice"
  $ runtest
  shopping list:
  lime -> gimlet

Nice. Notice that I can no longer just buy lime cordial, as that won't be
sufficient -- can't make lime juice out of lime cordial.

Now I suspect that there's a bug in my current implementation, so let's make a
silly-looking test where a recipe uses both an ingredient and a potential output
of that ingredient:

  $ empty_bar
  $ add_recipe "sour limes" "lime" "lime juice"
  $ runtest
  shopping list:
  lime -> sour limes

And this did detect the bug! But now I've fixed it, and everything is fine.

But I think I might have another bug. Does the Has relation work through
arbitrarily long Begets production chains?

  $ empty_bar
  $ empty_recipe_book
  $ echo 'really really specific scotch -> specific scotch' >>begets
  $ echo 'really specific scotch -> specific scotch' >>begets
  $ echo 'specific scotch -> scotch' >>begets
  $ add_recipe "shot of scotch" scotch
  $ runtest
  shopping list:
  scotch -> shot of scotch
  really really specific scotch -> shot of scotch
  specific scotch -> shot of scotch
  really specific scotch -> shot of scotch

It didn't, the first time I tried this. But now I've fixed it.

Now let's make sure that the "unbuyable" list is filtering things out correctly.

  $ empty_recipe_book
  $ add_recipe gimlet gin "lime juice" "lime cordial"
  $ buy "lime" "gin"
  $ runtest
  shopping list:
  lime cordial -> gimlet
  sugar -> gimlet

Okay, but I can't find lime cordial in a store, so that line is kind of just
noise to me.

  $ echo "lime cordial" >> unbuyable
  $ runtest
  shopping list:
  sugar -> gimlet

There we go. But just because I can't usually buy it doesn't mean I can't use
it to mix the drink, if I happen to have some on hand:

  $ buy "lime cordial"
  $ runtest
  mixable: gimlet

The "Unbuyable" relation only affects output of the "Enables" relation.
