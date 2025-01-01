# WWE Network link map

## Purpose

When the WWE Network version 2 was launched in July 2019, all the previous
video links were rendered invalid. This database tries to provide a mapping
from the old links to the new ones, to help site owners with deep links to
migrate their pages.

When the WWE Network version 3 was launched in August 2023, they again
rendered all old video links invalid. I then updated the mapping to provide
links from both version 1 and version 2 to the version 3 links.

In January 2025, Netflix aquired all the assets of WWE Network where I
live. The WWE Network links are still active for the territories where the
Network is still live, but there is no transfer to Netflix for me, so I
added another map.

## Current state

The list is far from complete, it only contains the events that I had linked
in my database. Additions are welcome.

## File format

The mapping file is a simple comma-separated file, where the first line
contains a header.

The fields are as follows:

 1. Version 1 ID. This is just the numerical ID, the initial link part
   (often `http://network.wwe.com/video/v`) is omitted.
    If this field is `-` the video did not exist in version 1, or if I
    do not have the version 1 video ID available.
 2. Version 2 ID. This is with the prefix
   (`https://watch.wwe.com/episode/`) omitted. If starting with a /,
    relative to `https://watch.wwe.com/`.
 3. Promotion (WWE, WCW, ECW, NXT, NXT UK)
 4. Year.
 5. Event title.
 6. Version 3 ID. This is with the prefix
   (`https://network.wwe.com/video/`) omitted. The name part after
    the second slash is optional (if included).
 7. Netflix ID. This is with the prefix
   (`https://www.netflix.com/watch/`) omitted.

## Scripts

The script `rewritehtml.perl` can be used to rewrite links in HTML pages.
Run it from the database directory and pass the names of the files you wish
to rewrite as parameters. It will update all known links, leaving any
links not mapped in the database alone.

## Author

 * Peter Krefting
   peter@softwolves.pp.se

   http://www.softwolves.pp.se/wrestling/

## Contributors

