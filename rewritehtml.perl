#!/usr/bin/perl -w
#
# This script rewrites old WWE Network links in HTML files list on its
# command-line to the new style, using the mappings in database.csv
#
# Usage:  rewritehtml.perl a.html b.html ...
#
# Example:
#   rewritehtml.perl $(grep http://network.wwe.com/video/ *.html)

use strict;

if ($#ARGV < 0)
{
    print "Usage: $0 filename ...\n\n";
    print "Rewrites WWE Network links in the files listed on the command line\n";
    exit 1;
}

my %map;
&readdatabase('database.csv');

foreach my $file (@ARGV)
{
    &process($file);
}
exit 0;

# Read the database
sub readdatabase
{
    my $fn = shift;
    open my $db, '<', $fn
        or die "Unable to open $fn: $!\n";
    print "Reading $fn ...\n";
    my $header = <$db>;
    while (my $line = <$db>)
    {
        chomp $line;
        my @tokens = split(/,/, $line, 5);
        # Map if we have something to map to
        my $videoid = int($tokens[0]);
        if ($tokens[1] ne '')
        {
            die "Duplicate mapping for $tokens[0]" if defined $map{$videoid};
            $map{$videoid} = $tokens[1];
        }
    }
    print "... done\n";
}

# Rewrite one document
sub process
{
    my $fn = shift;
    print "Converting $fn...\n";
    open my $in, '<', $fn
        or die "Unable to read $fn: $!\n";
    open my $out, '>', $fn . '.new'
        or die "Unable to write $fn.new: $1\n";

    # Parse line by line
    my $found = 0;
    while (my $line = <$in>)
    {
        my $pos = 0;
        # Find all old video links
        while ((my $match = index($line, 'http://network.wwe.com/video/v', $pos)) != -1)
        {
            # Find the video number
            (my $videoidstr, my $ignore) = split(/[^0-9]/, substr($line, $match + 30), 2);
            my $videoid = int($videoidstr);
            if (defined $map{$videoid})
            {
                # Rewrite to new video
                my $newstr = $map{$videoid};
                if (substr($newstr, 0, 1) eq '/')
                {
                    substr($line, $match, 30 + length($videoid)) = "https://watch.wwe.com" . $map{$videoid};
                }
                else
                {
                    substr($line, $match, 30 + length($videoid)) = "https://watch.wwe.com/episode/" . $map{$videoid};
                }
                ++ $found;
            }
            $pos = $match + 30;
        }
        # Write to output
        print $out $line;
    }
    close $out;
    close $in;

    if ($found)
    {
        print "... done with $found substitutions; overwriting\n";
        rename("$fn.new", $fn);
    }
    else
    {
        print "... done, no links changed\n";
        unlink("$fn.new");
    }
}
