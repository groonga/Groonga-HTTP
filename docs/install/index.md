---
title: Install
---

# Install

This document how to install Groonga-HTTP on the following platforms:

  * [AlmaLinux](#almalinux)

We must install [Groonga][groonga] before installing Groonga-HTTP.

Groonga-HTTP provides by CPAN.
The following install procedure is if we use Groonga-HTTP that provides in CAPN.

## AlmaLinux {#almalinux}

```console
% sudo dnf install -y perl-App-cpanminus
% sudo dnf install -y gcc
% cpanm Groonga-HTTP
```

[Groonga]:https://groonga.org/
