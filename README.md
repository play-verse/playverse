# eternity-legend

[![sampctl](https://img.shields.io/badge/sampctl-eternity--legend-2f2f2f.svg?style=for-the-badge)](https://github.com/nathanramli/eternity-legend)

<!--
Short description of your library, why it's useful, some examples, pictures or
videos. Link to your forum release thread too.

Remember: You can use "forumfmt" to convert this readme to forum BBCode!

What the sections below should be used for:

`## Installation`: Leave this section un-edited unless you have some specific
additional installation procedure.

`## Testing`: Whether your library is tested with a simple `main()` and `print`,
unit-tested, or demonstrated via prompting the player to connect, you should
include some basic information for users to try out your code in some way.

And finally, maintaining your version number`:

* Follow [Semantic Versioning](https://semver.org/)
* When you release a new version, update `VERSION` and `git tag` it
* Versioning is important for sampctl to use the version control features

Happy Pawning!
-->

## Installation

Cara install:

```bash
git pull
sampctl package install
sampctl package ensure
```

### Cara compile :

Development server
```bash
sampctl package build dev
```

Production server 
>_jika mengcompile menggunakan perintah ini, server harus dijalankan menggunakan **sampctl** juga_
```bash
sampctl package build prod
```


## Cara Run Server :
```bash
sampctl server run
```
