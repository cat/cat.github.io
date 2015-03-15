---
title: Overview
---

### Rationale 


The purpose of the cat library is twofold: 

* on the one hand it provides utilities and functions 
not available in the standard C++ library with respect to the functional programming. 
* on the other hand it provides a framework for building type classes, an abstraction
used in the Haskell language.


### Features

The cat library:

* is lightweight (headers only). Each function and object shipped with the library
takes advantage of modern C++ features, such as `constexpr` constructors and call 
operators, movability, perfect forwarding, etc.
* is written in pure and portable C++14, without using any macro black-magic and with
a limited use of template meta-programming, confined only in the implementation
of type traits.
* provides a set of type traits that extends the standard ones (e.g. `is_container`, 
`is_associative_container`, `function_type`, `function_arity`, `return_type`, `is_callable` 
to mention a few).
* provides functional utilities, like callable wrappers, which enable functional
composition and currying on-top-of any kind of callable objects (including `std::bind` 
expressions and generic lambdas).
* provides utilities that operate on `std::tuple` and generic containers. 
In particular `forward_as` and `forward_iterator` enable perfect forwarding in 
for-loop statements and with the use of iterators.  
* includes an extensible framework for building type classes and provides the
implementation of the following ones:
    * Functor
    * Bifunctor
    * Applicative
    * Alternative 
    * Monoid 
    * Monad
    * MonadPlus
    * Foldable
    * Show
    * Read

* provides instances of standard C++ types and containers for the above-mentioned type classes.

### Notes

At the present moment the Cat library is tested under Linux with both glibcxx and libc++
library and with the following compilers:
    
* gcc-4.9
* gcc-5 
* clang-3.5 
* clang 3.6 


### Acknowledgements

* The [Haskell](https://www.haskell.org) language
* [Fit library](https://github.com/pfultz2/Fit) by Paul Fultz II
* [FTL library](https://github.com/beark/ftl) by Bjorn Aili

