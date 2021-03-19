# mixologic

Pronounce it with the stress on the second syllable, like "mixology." Don't pronounce it like "mix-o-logic." That sounds awful.

This is the code accompanying an as-yet-unpublished blog post. That I haven't even finished writing yet. So you're really snooping around, huh?

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

# testing

From within `nix-shell`:

    $ cram test.t --shell=$SHELL -i

To run the tests.
