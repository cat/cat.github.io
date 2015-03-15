---
title: Overview
---


### The purpose of cat is twofold: 

* on the one hand it provides utilities and functions 
not available in the standard C++ library with respect to the functional programming. 
* on the other hand it provides a framework of type classes used in the Haskell language.



### The cat library:


* is lightweight (headers only) where every function and object take advantage
of modern C++ features, such as `constexpr`, moveability, perfect forwarding, 
virtual function desugaring (`final`), and static polymorphism.
* is written in pure and portable C++14, without using the macro black-magic and with
a limited use of template meta-programming, confined only in the implementation
of type traits.
* provides a set of type-traits that extend the standard ones, with respect to
functional programming (e.g. `is_container`, `is_associative_container`, `function_type`,
`arity`, `is_callable` to mention a few).
* provides functional utilities, like callable wrappers which enable currying on 
virtually any kind of callable objects (including `std::bind` expressions and generic lambdas).
* provides utilities that operate on `std::tuple` and generic containers. In particular
the implementation of `forward_as` and `forward_iterator` enable perfect forwarding 
in for-loop statements and with the iterator paradigm.
* provides the machinary to build type classes, an extensible framework based on
static polymorphism.
* provides instances of standard C++ types and containers for the following type-classes:
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
* is tested with the following compilers:
    * gcc-4.9
    * gcc-5 
    * clang-3.5 
    * clang 3.6 
    * both glibcxx and libc++ libraries.

