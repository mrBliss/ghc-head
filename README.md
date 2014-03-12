This is a fork of the GHC code base, in which we are working on an
implementation of partial type signatures. Our proposed design is described in
the paper _Partial Type Signatures for Haskell_ (Practical Aspects of
Declarative Languages 2014). This implementation is a work-in-progress.

# Building #

To try out the modified compiler, you have to build it. GHC upstream build
instructions are available at
[http://hackage.haskell.org/trac/ghc/wiki/Building][] and we recommend to
follow them. Here is a summarised version that should work (with Linux-style
commands):

1. Install required development tools like `hsc2hs`, `happy`, `gcc`, certain C
   development libraries, `automake`, `autoconf`, etc. See
   http://hackage.haskell.org/trac/ghc/wiki/Building/Preparation. If you use
   Debian or Ubuntu Linux, you can use the command `sudo apt-get build-dep
   ghc6`.

        ...  # install all needed packages...

2. Clone the main GHC repository:

        git clone git://git.haskell.org/ghc.git

3. Go to the directory where you have checked out the repository:

        cd ghc

3. Check out (the correct versions of) sub-repositories (for Haskell libraries
   and tools):

        ./sync-all get

4. Add our fork as a git remote and fetch the code:

        git remote add partial-sigs https://github.com/mrBliss/ghc-head.git
        git fetch partial-sigs

5. Check out our branch

        git checkout partial-sigs

6. Build GHC. You can use for example `make -j4` instead of `make` to speed up
   compilation on a multi-core computer.

        cp mk/build.mk.sample mk/build.mk
        sed -i 's/#BuildFlavour = quick$/BuildFlavour = quick/' mk/build.mk
        perl boot && ./configure
        make -j4

7. Play with the compiler. Be sure to look at the examples of partial type
   signatures in `Demo.hs`. To run the demo file, execute the following
   command from the base dir of your GHC checkout.

        ./inplace/bin/ghc-stage2 --interactive Demo.hs
