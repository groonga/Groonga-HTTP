---
title: Install
---

# Install

This document how to install Groonga-HTTP on the following platforms:

  * [AlmaLinux 8](#install-on-8)

We must install [Groonga][groonga] before installing Groonga-HTTP.

Groonga-HTTP provides by CPAN.
The following install procedure is if we use Groonga-HTTP that provides in CAPN.

## AlmaLinux 8 {#install-on-8}

```console
% sudo dnf install -y perl-App-cpanminus
% sudo dnf install -y gcc
% cpanm Groonga::HTTP
```

If we want to use Carton to install Groonga-HTTP, we install Groonga-HTTP in the following procedure.

At first, we write cpanfile sunch as the follow.

```
requires 'Groonga::HTTP'
```

Second, we execute the following commands

```console
% sudo dnf install -y perl-App-cpanminus
% sudo dnf install -y gcc
% cpanm Carton
% carton install
```

[Groonga]:https://groonga.org/
