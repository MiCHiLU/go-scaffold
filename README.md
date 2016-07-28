features
--------

* i18n

initial setup
-------------

First, setup [goenv](https://bitbucket.org/ymotongpoo/goenv). Then:

    $ git clone --branch master --depth 1 https://github.com/MiCHiLU/go-scaffold.git
    $ mkvirtualenv go-scaffold
    (go-scaffold)$ goof make go-scaffold
    (go:go-scaffold) (go-scaffold)$ echo 'goof go go1.6.3\nexport PATH="$GOBIN":"$GOROOT/bin":$PATH' >> activate
    (go:go-scaffold) (go-scaffold)$ deactivate && goof workon go-scaffold
    (go:go-scaffold) (go-scaffold)$ make setup

## Set up submodules

    $ git submodule init
    $ git submodule update

## Get go libraries

    $ go get github.com/jteeuwen/go-bindata/...
    $ go get github.com/samuel/go-gettext

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
