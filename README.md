features
--------

* i18n

initial setup
-------------

    $ mkvirtualenv go-scaffold
    (go-scaffold)$ goof make go-scaffold
    (go:go-scaffold) (go-scaffold)$ make setup

workon
------

    $ workon go-scaffold
    (go-scaffold)$ goof workon go-scaffold
    (go:go-scaffold) (go-scaffold)$

get go libraries
----------------

    $ go get github.com/samuel/go-gettext
    $ go get github.com/jteeuwen/go-bindata/...

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
