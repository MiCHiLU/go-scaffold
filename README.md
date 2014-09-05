[![Build Status](https://travis-ci.org/MiCHiLU/go-scaffold.svg?branch=master)](https://travis-ci.org/MiCHiLU/go-scaffold)

features
--------

* i18n

initial setup
-------------

    $ goenv go-scaffold
    Directory './go-scaffold' exist.
    Do you want overwrite it? [y/N]: y
    Environment ./go-scaffold created!
    $ mkvirtualenv go-scaffold
    (go-scaffold)$ goof workon go-scaffold
    (go:go-scaffold) (go-scaffold)$ make setup

workon
------

    $ workon go-scaffold
    (go-scaffold)$ goof workon go-scaffold
    (go:go-scaffold) (go-scaffold)$

build and run
-------------

    $ make && ./bin/go-scaffold
    go-scaffold 0.0.0.1 (fd79f0a+, Sep 05 05:21:18 2014, darwin/amd64)
    2014/09/05 13:21:22 Finished: 33.457us

    $ LANG=ja ./bin/go-scaffold -h
    Usage: ./bin/go-scaffold [options]

      -i=0: インターバル
      -v=false: デバッグメッセージを表示する

dependencies
------------

* go-bindata v2.0.4
* pybabel
