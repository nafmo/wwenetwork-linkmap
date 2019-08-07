# WWE Network link map

## Purpose

When the WWE Network version 2 was launched in July 2019, all the previous
video links were rendered invalid. This database tries to provide a mapping
from the old links to the new ones, to help site owners with deep links to
migrate their pages.

## Current state

The list is far from complete. Additions are welcome.

Known issues:

 * Some events have the wrong caption; a number of weekly episodes of Raw,
   SmackDown and other shows are listed under PPV names, usually because
   they contain events leading up to these events.
 * A lot of the stuff hasn't been filled in yet.

## File format

The mapping file is a simple comma-separated file, where the first line
contains a header.

The fields are as follows:

 1. Old video ID. This is just the numerical ID, the initial link part
   (often `http://network.wwe.com/video/`) is omitted.
 2. New video ID. This is with the prefix
   (`http://watch.wwe.com/episode/`) omitted.
 3. Promotion (WWE, WCW, ECW, NXT, NXT UK)
 4. Year.
 5. Event title.

## Author

 * Peter Krefting
   peter@softwolves.pp.se

   http://www.softwolves.pp.se/wrestling/

## Contributors

