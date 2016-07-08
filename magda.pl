#!/usr/bin/perl -w
use strict;

my ($existing,$new,$tar);
my $backup   = "\<UNDEFINED\>";
my $timestamp = `date +%Y-%m-%d_%T`;chomp($timestamp);
my @push;
my ($recordsT, $matchedT, $notmatchedT) = ("0","0","0");
#`rm /var/tmp/MAGDA* > /dev/null 2>&1`;

if (!$ARGV[0] or !$ARGV[1])
{
	print "use: ./magda.pl \$direct_path_to_exising_BE_filter \$direct_path_to_new_BE_filter\n\n";
	exit;
}
else
{
	$existing 	= $ARGV[0];chomp($existing);
	$new 		= $ARGV[1];chomp($new);
}
my ($debug,$modify) = ("0","0");
if ($ARGV[2] and $ARGV[2] =~ m/^\-/)
{
	$debug++  if ($ARGV[2] =~ m/d/i);
	$modify++ if ($ARGV[2] =~ m/m/i);
}

my @e_raw = `cat $existing`; my $e_raw_ct = scalar(@e_raw);
shift @e_raw if ($e_raw[0] =~ m/new/);
my @n_raw = `cat $new`; my $n_raw_ct = scalar(@n_raw);
shift @n_raw if ($n_raw[0] =~ m/new/);
print "\n";
print "                  Existing Filter: $existing\n";				
print "       Existing Filter Line Count: $e_raw_ct\n";
print "                       New Filter: $new\n";				
print "            New Filter Line Count: $n_raw_ct\n\n";
my $tct = 0;
foreach my $templine (@n_raw)
{
	if ($templine =~ m/(\!\=[^\"])/g)
	{
		my $tmphdr = $1 if ($templine =~ m/^\d+\s(\w+|\".*\")\s/);
		print "  \[FILTER SKIPPED\]  $tmphdr: Skipped due to anomalous filter syntax.\n";
		splice @n_raw, $tct, 1;	
	}
	$tct++;
}
print "\n\n                              #############################################\n                              #           NEW FILTER COMPARRISON          #\n                              #############################################\n\n";
printf ("%30.30s%15.15s%15.15s%15.15s\n","Rule","Records","Matched","Not-Matched");

foreach my $nline (@n_raw)
{
	chomp($nline);
	my ($key,$data,$data_parsed_ct,$mat,$nmat) = ("Null","Null","0","0","0");
	my @data_parsed;
	my @notmatched;
	$key = $1 if ($nline =~ m/^\d+\s(\w+|\".*\")$/);
	($key,$data) = ("$1","$2") if ($nline =~ m/^\d+\s(\w+|\".*\")\s(.*)$/);
	if ($data ne "Null")
	{
		$data = $1 if ($data =~ m/.(.*)/);
		@data_parsed = split('!=',$data);
		foreach (@data_parsed)
		{
			$_ = '!'."$_"  if ($_ =~ m/^\=/);
			$_ = '!='."$_" if ($_ =~ m/^\"/);
		}
		$data_parsed_ct = scalar(@data_parsed);
	}
	my @found = grep(/7\s$key/,@e_raw);
	foreach my $nfilter (@data_parsed)
	{
		if ($found[0] =~ m/\Q$nfilter\E/)
		{
			$mat++;
		}
		else
		{
			push @notmatched, $nfilter;
			push @push, "$key".','."$nfilter";
		}
	}
	my $notmatched_ct = scalar(@notmatched);
	printf ("%30.30s%15.15s%15.15s%15.15s\n","$key","$data_parsed_ct","$mat","$notmatched_ct");
	$recordsT    = $recordsT + $data_parsed_ct;
	$matchedT    = $matchedT + $mat;
	$notmatchedT = $notmatchedT + $notmatched_ct;
	if ($debug > 0 and $notmatched_ct > 0){foreach (@notmatched){print "NOT-MATCHED: $_\n";}}
}
printf ("\n%30.30s%15.15s%15.15s%15.15s\n\n","TOTALS:","$recordsT","$matchedT","$notmatchedT");

if ($modify > 0)
{
	my $push_ct = scalar(@push);
	if ($push_ct == 0){print "                             There are no filters to add!\n                             Script exiting.\n\n";exit;}
	unshift @e_raw, '//new2';
	foreach my $pline (@push)
	{
		if ($pline =~ m/^(.*)\,(\!\=.*)$/)
		{
			my ($keyP,$filterP) = ("$1","$2");
			foreach my $eline (@e_raw)
			{
				chomp($eline);
				$eline = join(' ', $eline,$filterP) if ($eline =~ m/^7\s\Q$keyP\E/);
			}
		}
	}
	my $ect = scalar(@e_raw);
	my $cpfile = "NULL";
	until ($cpfile =~ m/^yes$|^no$/i)
	{
		print "Do you want to provision the new file ($ect lines)? (yes/no): ";
		$cpfile = <STDIN>;
	}
	if ($cpfile =~ m/yes/i)
	{
		print "Provisioning new filters: ";
		open(my $fh, '>', $existing);
		foreach (@e_raw)
		{
			$_ =~ s/\cM//;
			print $fh "$_\n";
		}
		close($fh);
		print "COMPLETE\n\n";
	}
	else
	{
		print "Script terminating...\nDone.\n\n";
	}
}
