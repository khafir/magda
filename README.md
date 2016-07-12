# magda.pl

Perl script (parser) for the automated comparison and addition of Battleye (BE) filters. Designed for and only tested against the  Exile@ARMAIII platform in a CentOS-7 environment.

#Before Proceeding
Be smart about making changes to your Battleye (BE) filters. Backup whatever file(s) you plan on modifying with this script before using it. This script has the functionality to generate new BE filter files and over-write existing filter files, so do yourself a favor and backup your existing filters before using this script.

#Installation
1. Move magda.pl to your directory of choice.
2. Modify permissions for magda.pl appropriate with your environment.

#Execution Syntax
<code>./magda.pl</code><br>
<code>usage: ./magda.pl $direct_path_to_exising_BE_filter_file $direct_path_to_new_BE_filter_file</code><br>
<code>example: ./magda.pl ./battleye/scripts.txt ./newBEfilters/scripts.txt -m</code><br>
<code>example: ./magda.pl ./battleye/scripts.txt ./newBEfilters/scripts.txt</code><br>


#Example Output
<code>
./magda.pl ./battleye/scripts.txt ./newBEfilters/scripts.txt -m

                    Existing Filter: /home/steam/steamcmd/arma3/battleye/scripts.txt
         Existing Filter Line Count: 55
                         New Filter: /home/steam/steamcmd/arma3/newBEfilters/scripts.txt
              New Filter Line Count: 37  
    [FILTER SKIPPED]  playableUnits: Skipped due to anomalous filter syntax.

                                #############################################
                                #           NEW FILTER COMPARRISON          #
                                #############################################

                            Rule        Records        Matched    Not-Matched
                      createUnit              1              1              0
                      createTeam              0              0              0
                     createAgent              2              0              2
                   callExtension              0              0              0
              showCommandingMenu              3              0              3
        setUnitRecoilCoefficient              1              0              1
          setWeaponReloadingTime              3              1              2
                      drawline3d              1              0              1
                     onEachFrame              1              1              0
                onMapSingleClick              1              1              0
                        loadFile              0              0              0
                    createMarker              5              5              0
               createVehicleCrew              0              0              0
               deleteVehicleCrew              3              3              0
               allMissionObjects             10              8              2
                         setAmmo              3              3              0
                      setDammage              0              0              0
                       setDamage             10              7              3
                    allVariables              3              1              2
                      allPlayers             10              7              3
                        allUnits              2              2              0
                        entities             10             10              0
                       allGroups              1              1              0
                       camCreate              5              3              2
                    selectCamera              0              0              0
            removeMPEventHandler              0              0              0
        removeAllMPEventHandlers              0              0              0
                 nearestBuilding              0              0              0
                    addGroupIcon              0              0              0
                      hideObject              4              2              2
            disableCollisionWith              5              4              1
                    _allocMemory              1              1              0
    "!(isNil \"FN_infiSTAR_C\")"              0              0              0
                "Ammo Activated"              0              0              0
           "     +             "              0              0              0

                         TOTALS:             85             61             24
                       
      Do you want to provision the new file (55 lines)? (yes/no): yes
      Provisioning new filters: COMPLETE</code>

#Default Output
Default output is gained by executing the script without a third paramater. The output will will mirror the example above but the user will not be prompted to confirm changes and no changes will be made.

#Optional Parameters
You may elect to use the additional third paramater of (-m) to enable modification. When using this parameter you will be promted as in the example above to confirm whenther or not you want to provision (add) the changes suggested by the script or not. <b>If you answer yes, if you confirm the addition of the changes, the existing file will be over-written without further prompts or confirmation.</b>

#Information of Note
In the example above you will see the following line of text near the top:
<code><br>[FILTER SKIPPED]  playableUnits: Skipped due to anomalous filter syntax.</code>

There is a condition where a filter will have an embedded '!=' within the construct. Due to the nature of how the script parses the filter file the script will skip comparrison and addition logic for lines where this condition is present. Should this circumstance arise, you will need to look at the new filter file, capture the filters for that particular filter keyword, and transfer them as appropriate to your existing BE filter file.

Of further note regarding the quality and organization of the code; I know this code is not stuctured in the most efficient manner but it is functional as I've tested it. My goal was to have this script completed in advance of the Apex release, further updates will feature a code cleanup and possibly additional features.

#Change Log
v1.1  12-JUL-2016 Updated line parsing logic to reflect changes with 'Potato' format entries for battleye/scripts.txt
