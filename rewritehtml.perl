#!/usr/bin/perl -w
#
# This script rewrites WWE Network v1 or v2 links in HTML files list on its
# command-line to the v3 style, using the mappings in database.csv
#
# Usage:  rewritehtml.perl a.html b.html ...
#
# Example:
#   rewritehtml.perl $(grep http://network.wwe.com/video/ *.html)

use strict;
use Text::CSV;

if ($#ARGV < 0)
{
    print "Usage: $0 filename ...\n\n";
    print "Rewrites WWE Network links in the files listed on the command line\n";
    exit 1;
}

my (%map, %mapv2);
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
    my $csv = Text::CSV->new;
    open my $db, '<', $fn
        or die "Unable to open $fn: $!\n";
    print "Reading $fn ...\n";
    my $header = <$db>;
    while (my $line = <$db>)
    {
        chomp $line;
        $csv->parse($line) or die "Unable to parse $line";
        my @tokens = $csv->fields();
        # Map if we have something to map to
        if ($tokens[0] ne '-')
        {
            my $videoid = int($tokens[0]);
            if ($tokens[1] ne '')
            {
                die "Duplicate mapping for $tokens[0]" if defined $map{$videoid};
                if ($tokens[5] ne '' && $tokens[5] ne '-')
                {
                    $map{$videoid} = $tokens[5];
                }
            }
        }
        my $v2id = 0;
        if ($tokens[1] =~ /-([1-9][0-9]+)$/)
        {
            $v2id = $1;
        }
        if ($v2id != 0)
        {
            die "Duplicate mapping for $v2id" if defined $mapv2{$v2id};
            if ($tokens[5] ne '' && $tokens[5] ne '-')
            {
                $mapv2{$v2id} = $tokens[5];
            }
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
        # FIXME: http://network.wwe.com/share/video/2519716183
        while ((my $match = index($line, 'http://network.wwe.com/video/v', $pos)) != -1)
        {
            # Find the video number
            (my $videoidstr, my $ignore) = split(/[^0-9]/, substr($line, $match + 30), 2);
            my $videoid = int($videoidstr);
            if (defined $map{$videoid})
            {
                # Rewrite to new video
                substr($line, $match, 30 + length($videoid)) = "https://network.wwe.com/video/" . $map{$videoid};
                ++ $found;
            }
            $pos = $match + 30;
        }
        while ((my $match = index($line, 'https://watch.wwe.com/', $pos)) != -1)
        {
            # Find the video number
            my $videoid = 0;
            my $videoidlen = 0;
            if (substr($line, $match + 22) =~ /((episode|program)\/[A-Za-z0-9-]+-([1-9][0-9]+))/)
            {
                my $videoidstr = $3;
                $videoidlen = length($1);
                $videoid = int($videoidstr);
            }
            if (defined $mapv2{$videoid})
            {
                # Rewrite to new video
                substr($line, $match, 22 + $videoidlen) = "https://network.wwe.com/video/" . $mapv2{$videoid};
                ++ $found;
            }
            $pos = $match + 22;
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
