# Madness Cards for Out of the Abyss

Tools for building PDF & PNG files suitable for printing on card stock, or
sending to a printer of game cards.

Starting with [John Scott’s MS Word
documents](https://drive.google.com/drive/folders/0B0Pt2Npati8kUDBDMGJpYXBjWVE)
as inspiration, these cards have been reedited, reformatted, and reimagined.

## Artwork

<dl>
  <dt><strong>Short-Term Madness</strong></dt>
  <dd><a href="https://cyliondraw.deviantart.com/art/Death-City-308883109">“Death City” © 2012-2018 CylionDraw</a></dd>
  <dt><strong>Long-Term Madness</strong></dt>
  <dd><a href="https://www.artstation.com/alexineskiba">“Devil 2” © 2016-2018 Skyrawathi</a></dd>
  <dt><strong>Indefinite Madness</strong></dt>
  <dd>
    <a href="https://m-delcambre.deviantart.com/art/Give-the-power-Cinematic-636055290">“Give
    the Power” by M-Delcambre</a>,
    <a href="https://creativecommons.org/licenses/by-nc-nd/3.0/">CC BY-NC-ND 3.0</a>
  </dd>
  <dt><strong>Acting Tips Sock and Buskin Masks</strong></dt>
  <dd>
    <a href="https://commons.wikimedia.org/w/index.php?curid=54724150">Comedy
    and tragedy masks without background.svg</a>, by The Anome, from original
    source <a href="//commons.wikimedia.org/wiki/File:Teatro.svg">Teatro.svg</a>
    by Booyabazooka on English Wikipedia, he:משתמש:נעמה מ on Hebrew Wikipedia.
    <a href="https://creativecommons.org/licenses/by-sa/3.0"
    title="Creative Commons Attribution-Share Alike 3.0">CC BY-SA 3.0</a>.
  </dd>
</dl>

## Prerequisites

To build a PDF of the cards requires
[xsltproc](http://xmlsoft.org/XSLT/xsltproc2.html) from libxstl2, [Apache FOP
2.x](https://xmlgraphics.apache.org/fop/), and [ImageMagick](https://www.imagemagick.org)

To also build PNG files requires [Ghostscript](https://www.ghostscript.com/).

My own PDFs use the Cochin typeface.

### MacOS

I strongly recommend installation via [Homebrew](https://brew.sh).

1. make and xsltproc are included in the
   [Command-Line Tools for Xcode](https://developer.apple.com/download/more/),
   which you’ll also need for Homebrew.
1. `brew install fop imagemagick`
1. If you want to make PNGs `brew install ghostscript` _or_ combined into a
   single command: `brew install fop imagemagick ghostscript`

#### Fonts

If you wish to use the Cochin typeface you can extract the TTF
files out of the TTC file in `/Library/Fonts/Cochin.ttc`. [This
Gist](https://gist.github.com/lilydjwg/8877450) works for fontforge installed
via Homebrew if you change the shebang to use `python2.7` instead of `python3`.

### Fedora / RHEL 7 / CentOS 7

1. [RHEL/CentOS only:] In order to install FOP you’ll need EPEL installed if you
   don’t already have it: `yum install -y epel-release`.
1. `yum install -y make libxslt ImageMagick fop`
1. If you want to make PNGs: `brew install -y ghostscript`

**RHEL / CentOS Note:** At the time of this writing EPEL installs fop-1.1 and
will likely do so for the lifetime of RHEL7. I do not believe I’m using any
XSL:FO not supported by 1.1, but it has been a long time since I used 1.1, and I
am not explicitly testing on 1.1.

### Debian / Ubuntu

1. `apt-get install -y fop imagemagick xsltproc`
1. If you want to make PNGs: `install -y ghostscript`

### Windows

No idea, sorry. FOP is Java-based, so you should be able to download and run it
once you have Java installed. And I believe libxslt & ghostscript have
provisions for installing on Windows, though they may or may not require Cygwin.

If someone with a Windows box gets it working, I’d love a docs PR.

## Usage

### Building the PDF

Provided xsltproc & fop are in your PATH, you should be able to run `make` and
it will produce a PDF named `cards.pdf`:

```
% make
xsltproc -o cards.fo cards-fo.xsl cards.xml
fop -c fonts/userconfig.xml cards.fo cards.pdf
2018-05-08 07:37:23.963 java[87241:14203638] ApplePersistence=NO
May 08, 2018 7:37:31 AM org.apache.fop.events.LoggingEventListener processEvent
INFO: Rendered page #1.
May 08, 2018 7:37:31 AM org.apache.fop.events.LoggingEventListener processEvent
INFO: Rendered page #2.
[ … ]
May 08, 2018 7:37:34 AM org.apache.fop.events.LoggingEventListener processEvent
INFO: Rendered page #53.
May 08, 2018 7:37:34 AM org.apache.fop.events.LoggingEventListener processEvent
INFO: Rendered page #54.
```

#### About Font Files

If you do not have the Cochin TTF files in the `fonts` directory matching the
names in the `fonts/userconfig.xml` file, fop will error out with a Java
FileNotFoundErrors for these files:

```
[…]
May 08, 2018 7:42:21 AM org.apache.fop.fonts.LazyFont load
SEVERE: Failed to read font metrics file null
java.io.FileNotFoundException: /Users/erik/work/madness_cards/fonts/Cochin.ttf (No such file or directory)
[…]
```

In this case you have a few options:

1. [Extract](#fonts), or buy a copy of the Cochin font files, and place them in
   the expected locations.
1. Find a similar, free font and place it in the directory, changing the
   `userconfig.xml` file to match. You may have to edit the cards to allow the
   text on them to fit, since the letter-spacing will have changed.
1. Modify the Makefile to remove the `-c $<` so that the configuration file is
   not used. (**Not Recommended.** The cards will look terrible.)

#### About Card Sizing

I used poker playing cards as the template for these cards. [The company I used
to print mine](http://www.makeplayingcards.com/) specified their cards as
63×88mm, with ⅛" buffer lost to cutting, and another ⅛" “for safety.”

I’m very happy with my cards (I chose the 330gsm stock), and would definitely
recommend them. If you are using another printer, make sure you check their
sizing, and adjust accordingly. The cards _should_ render correctly at new
sizes, but you should spot check each card to ensure everything lines up and the
text all fits before sending them to the printer.

### Building PNG files

By default, PNGs will be created at 1200 dpi, allowing Ghostscript to use 512MB
as it builds them. To use these defaults run:

```
make png
```

That will create all of the cards (that do not have the `enabled="false"`
attribute set) in the cards directory: `cards/card-01.png` through
`cards/card-54.png`.

To change the defaults:

```
make PNG_DPI=300 GS_MEMORY=1073741824 png
````

## Creating New Cards

Unless you merely want to tweak the wording of an existing card, I recommend
creating new cards for all your changes. If you are limited in the number of
cards you can print, you can add an `enabled="false"` attribute to the cards you
want to leave out. (I have already done this on two cards in the deck, to make
room for two new ones.)

Each card is defined by a `<card>` entry in `cards.xml`. I happen to think the
DTD is pretty straightforward, but there are some points it’s probably worth
documenting by example:

```xml
<card duration="Short|Long|Indefinite">
  <title shrink="optional: if present, shrinks the text to try to fit it on one line. Use sparingly.">
    The Title Goes Here and Is Shown At the Top of the Card (The Stylesheet Does
    Not Gracefully Handle Titles That Wrap, So Keep It Short!)
  </title>
  <description>
    <line>
      Descriptions can either contain their text directly, in which case it is
      all run together in a single block.
    </line>
    <line>
      Or they can contain &lt;line&gt;s, which separate text into lines.
    </line>
    <line>Also: &lt;em&gt; and &lt;strong&lt; work as you might expect.</line>
  </description>
  <acting tight="if this is present, the spacing is tightened up to try to help it fit in a tight space">
    This portion of the card is optional. If present, it appears below the
    description, in the paper section, with a pair of Sock and Buskin Masks to
    denote acting tips. This section can also include &lt;line&gt;s.
  </acting>
</card>
```

# Contributing

New card contributions are certainly welcome. Fixes for typos, grammatical
errors, or clumsy wording are also welcome.

I’ve also debated adding a subtle texture to the flat black backgrounds of the
cards, as well as changing up the backgrounds of the title bars & duration tabs.

If you’re looking to tackle on any of these, let’s discuss it!

# License

Artwork copyrights all held with [their respective artist](#artwork), except
where otherwise noted. All other code is distributed under the [Affero General
Public License v3.0](blob/master/LICENSE), and is freely distributable under
that license.
