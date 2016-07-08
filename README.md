# magda.pl

Perl script (parser) for the automated comparison and addition of Battleye (BE) filters. Designed for and only tested against the  Exile@ARMAIII platform in a CentOS-7 environment.

#Before Proceeding
Be smart about making changes to your Battleye (BE) filters. Backup whatever file(s) you plan on modifying with this script before using it. This script has the functionality to generate new BE filter files and over-write existing filter files, so do yourself a favor and backup your existing filters before using this script.

#Installation
1. Move magda.pl to your directory of choice.
2. Modify permissions for magda.pl appropriate with your environment.

#Execution Syntax
<code>./magda.pl</code><br>
<code>usage: ./magda.pl $direct_path_to_exising_BE_filter $direct_path_to_new_BE_filter</code><br>
<code>example: ./magda.pl /home/steam/steamcmd/arma3/battleye/scripts.txt /home/steam/steamcmd/arma3/newBEfilters/scripts.txt</code><br>
<code>example: ./magda.pl /home/steam/steamcmd/arma3/battleye/scripts.txt /home/steam/steamcmd/arma3/newBEfilters/scripts.txt -m</code><br>
