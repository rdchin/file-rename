#!/bin/bash
#
# ©2020 Copyright 2020 Robert D. Chin
#
# Usage: bash file_recursive_rename.sh <TARGET DIRECTORY>
#        (not sh file_recursive_rename.sh)
#
# +----------------------------------------+
# |        Default Variable Values         |
# +----------------------------------------+
#
VERSION="2020-08-08 17:54"
THIS_FILE="file_recursive_rename.sh"
#
# +----------------------------------------+
# |            Brief Description           |
# +----------------------------------------+
#
#& Brief Description
#& 
#& This script will recursively rename files in the specified directory
#& and any sub-directories to enforce standard file naming conventions.
#& 
#& Files in hidden directories are excluded and are not renamed.
#& 
#& If you save articles from web pages as PDF files and use the title 
#& of the article as the PDF file name, you will probably end up with
#& various punctuation marks in your file name which are incompatible
#& or undesirable for any given Operating System (i.e. Unix, Linux,
#& Microsoft, Apple, Android).
#& 
#& Such file names derived from article titles often will contain
#& punctuation marks such as "?", "!", "/", "&", "%".
#& 
#& This script was written to enforce some of the file naming conventions
#& to ensure inter-Operating System compatibility.
#& 
#& It does not enforce all common file naming conventions, but only some
#& of the more common ones. See comments below for comprehensive list.
#& 
#& You may easily add more naming conventions in the "Start Main Program"
#& section of the script using the existing code as a template.
#& 
#&   Usage: bash file_recursive_rename.sh <TARGET DIRECTORY>
#&          bash file_recursive_rename.sh /home/user/Documents
#
# +----------------------------------------+
# |             Help and Usage             |
# +----------------------------------------+
#
#?    Usage: bash file_recursive_rename.sh [Target_Directory]
#?           bash file_recursive_rename.sh [OPTION]
#? Examples:
#?
#?bash file_recursive_rename.sh [Target_Directory] 
#?                                         # Rename files in directory.
#?
#?bash file_recursive_rename.sh --help     # Displays this help message.
#?                              -?
#?
#?bash file_recursive_rename.sh --about    # Displays script version.
#?                              --version
#?                              --ver
#?                              -v
#?
#?bash file_recursive_rename.sh --history  # Displays script code history.
#?                              --hist
#?
#? Examples using 2 arguments:
#?
#?bash example.sh --hist text
#?                --ver dialog
#
# +----------------------------------------+
# |           Code Change History          |
# +----------------------------------------+
#
## Code Change History
##
## (After each edit made, please update Code History and VERSION.)
##
## CODE HISTORY
##
## 2020-08-08 *Updated to latest standards.
##
## 2020-07-09 *Main Program added view and deleting of log file. 
##
## 2020-06-27 *f_display_common, f_about, f_code_history, f_help_message
##             rewritten to simplify code.
##
## 2020-06-26 *Main Program added acceptance of 2 arguments.
##            *f_arguments updated to latest standards.
##
## 2020-06-25 *Decision made not to be dependent on "common_bash_function.lib"
##             to limit size.
##
## 2020-04-28 *Main Program updated to latest standards.
##
## 2020-04-02 *Main Program minor enhancements.
##
## 2019-12-31 *Main Program excluded hidden directories from file
##             renaming process.
##
## 2019-05-10 *Main Program included time-stamp in log file names.
##            *Main Program added deletion of temporary files and 
##             unneeded log files.
##
## 2019-05-08 *Initial release.
#
# +----------------------------------------+
# |         Function f_script_path         |
# +----------------------------------------+
#
#     Rev: 2020-04-20
#  Inputs: $BASH_SOURCE (System variable).
#    Uses: None.
# Outputs: SCRIPT_PATH, THIS_DIR.
#
f_script_path () {
      #
      # BASH_SOURCE[0] gives the filename of the script.
      # dirname "{$BASH_SOURCE[0]}" gives the directory of the script
      # Execute commands: cd <script directory> and then pwd
      # to get the directory of the script.
      # NOTE: This code does not work with symlinks in directory path.
      #
      # !!!Non-BASH environments will give error message about line below!!!
      SCRIPT_PATH=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
      THIS_DIR=$SCRIPT_PATH  # Set $THIS_DIR to location of this script.
      #
} # End of function f_script_path.
#
# +----------------------------------------+
# |         Function f_arguments           |
# +----------------------------------------+
#
#     Rev: 2020-06-27
#  Inputs: $1=Argument
#             [--help] [ -h ] [ -? ]
#             [--about]
#             [--version] [ -ver ] [ -v ] [--about ]
#             [--history] [--hist ]
#             [] [ text ] [ dialog ] [ whiptail ]
#             [ --help dialog ]  [ --help whiptail ]
#             [ --about dialog ] [ --about whiptail ]
#             [ --hist dialog ]  [ --hist whiptail ]
#          $2=Argument
#             [ text ] [ dialog ] [ whiptail ] 
#    Uses: None.
# Outputs: GUI, ERROR.
#
f_arguments () {
      #
      # If there is more than two arguments, display help USAGE message, because only one argument is allowed.
      if [ $# -ge 3 ] ; then
         f_help_message text
         #
         clear # Blank the screen.
         #
         exit 0  # This cleanly closes the process generated by #!bin/bash. 
                 # Otherwise every time this script is run, another instance of
                 # process /bin/bash is created using up resources.
      fi
      #
      case $2 in
           "text" | "dialog" | "whiptail")
           GUI=$2
           ;;
      esac
      #
      case $1 in
           --help | "-?")
              # If the one argument is "--help" display help USAGE message.
              if [ -z $GUI ] ; then
                 f_help_message text
              else
                 f_help_message $GUI
              fi
              #
              clear # Blank the screen.
              #
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           --about | --version | --ver | -v)
              if [ -z $GUI ] ; then
                 f_about text
              else
                 f_about $GUI
              fi
              #
              clear # Blank the screen.
              #
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           --history | --hist)
              if [ -z $GUI ] ; then
                 f_code_history text
              else
                 f_code_history $GUI
              fi
              #
              clear # Blank the screen.
              #
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           -*)
              # If the one argument is "-<unrecognized>" display help USAGE message.
              if [ -z $GUI ] ; then
                 f_help_message text
              else
                 f_help_message $GUI
              fi
              #
              clear # Blank the screen.
              #
              exit 0  # This cleanly closes the process generated by #!bin/bash. 
                      # Otherwise every time this script is run, another instance of
                      # process /bin/bash is created using up resources.
           ;;
           "text" | "dialog" | "whiptail")
              GUI=$1
           ;;
           "")
           # No action taken as null is a legitimate and valid argument.
           ;;
           *)
              # Check for 1st argument as a valid TARGET DIRECTORY.
              if [ -d $1 ] ; then
                 TARGET_DIR=$1
              else
                 # Display help USAGE message.
                 f_message "text" "OK" "Error Invalid Directory Name" "\Zb\Z1This directory does not exist:\Zn\n $1"
                 f_help_message "text"
                 exit 0  # This cleanly closes the process generated by #!bin/bash. 
                         # Otherwise every time this script is run, another instance of
                         # process /bin/bash is created using up resources.
              fi
           ;;
      esac
      #
}  # End of function f_arguments.
#
# +----------------------------------------+
# |              Function f_abort          |
# +----------------------------------------+
#
#     Rev: 2020-05-28
#  Inputs: $1=GUI.
#    Uses: None.
# Outputs: None.
#
f_abort () {
      #
      # Temporary file has \Z commands embedded for red bold font.
      #
      # \Z commands are used by Dialog to change font attributes 
      # such as color, bold/normal.
      #
      # A single string is used with echo -e \Z1\Zb\Zn commands
      # and output as a single line of string wit \Zn commands embedded.
      #
      # Single string is neccessary because \Z commands will not be
      # recognized in a temp file containing <CR><LF> multiple lines also.
      #
      f_message $1 "NOK" "Exiting script" " \Z1\ZbAn error occurred, cannot continue. Exiting script.\Zn"
      exit 1
      #
      if [ -r  $TEMP_FILE ] ; then
         rm  $TEMP_FILE
      fi
      #
} # End of function f_abort.
#
# +------------------------------------+
# |          Function f_about          |
# +------------------------------------+
#
#     Rev: 2020-08-07
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2="NOK", "OK", or null [OPTIONAL] to control display of "OK" button.
#          $3=Pause $3 seconds [OPTIONAL]. If "NOK" then pause to allow text to be read.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: DELIM.
# Outputs: None.
#
#    NOTE: This function needs to be in the same library or file as
#          the function f_display_common.
#
f_about () {
      #
      # Display text (all lines beginning ("^") with "#& " but do not print "#& ").
      # sed substitutes null for "#& " at the beginning of each line
      # so it is not printed.
      DELIM="^#&"
      f_display_common $1 $DELIM $2 $3
      #
} # End of f_about.
#
# +------------------------------------+
# |      Function f_code_history       |
# +------------------------------------+
#
#     Rev: 2020-08-07
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2="NOK", "OK", or null [OPTIONAL] to control display of "OK" button.
#          $3=Pause $3 seconds [OPTIONAL]. If "NOK" then pause to allow text to be read.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: DELIM.
# Outputs: None.
#
#    NOTE: This function needs to be in the same library or file as
#          the function f_display_common.
#
f_code_history () {
      #
      # Display text (all lines beginning ("^") with "##" but do not print "##").
      # sed substitutes null for "##" at the beginning of each line
      # so it is not printed.
      DELIM="^##"
      f_display_common $1 $DELIM $2 $3
      #
} # End of function f_code_history.
#
# +------------------------------------+
# |      Function f_help_message       |
# +------------------------------------+
#
#     Rev: 2020-08-07
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2="NOK", "OK", or null [OPTIONAL] to control display of "OK" button.
#          $3=Pause $3 seconds [OPTIONAL]. If "NOK" then pause to allow text to be read.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: DELIM.
# Outputs: None.
#
#    NOTE: This function needs to be in the same library or file as
#          the function f_display_common.
#
f_help_message () {
      #
      # Display text (all lines beginning ("^") with "#?" but do not print "#?").
      # sed substitutes null for "#?" at the beginning of each line
      # so it is not printed.
      DELIM="^#?"
      f_display_common $1 $DELIM $2 $3
      #
} # End of f_help_message.
#
# +------------------------------------+
# |     Function f_display_common      |
# +------------------------------------+
#
#     Rev: 2020-08-07
#  Inputs: $1=GUI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2=Delimiter of text to be displayed.
#          $3="NOK", "OK", or null [OPTIONAL] to control display of "OK" button.
#          $4=Pause $4 seconds [OPTIONAL]. If "NOK" then pause to allow text to be read.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
# PLEASE NOTE: RENAME THIS FUNCTION WITHOUT SUFFIX "_TEMPLATE" AND COPY
#              THIS FUNCTION INTO ANY SCRIPT WHICH DEPENDS ON THE
#              LIBRARY FILE "common_bash_function.lib".
#
f_display_common () {
      #
      # Specify $THIS_FILE name of the file containing the text to be displayed.
      # $THIS_FILE may be re-defined inadvertently when a library file defines it
      # so when the command, source [ LIBRARY_FILE.lib ] is used, $THIS_FILE is
      # redefined to the name of the library file, LIBRARY_FILE.lib.
      # For that reason, all library files now have the line
      # THIS_FILE="[LIBRARY_FILE.lib]" deleted.
      #
      #================================================================================
      # EDIT THE LINE BELOW TO DEFINE $THIS_FILE AS THE ACTUAL FILE NAME WHERE THE 
      # ABOUT, CODE HISTORY, AND HELP MESSAGE TEXT IS LOCATED.
      #================================================================================
                                           #
      THIS_FILE="file_recursive_rename.sh" # <<<--- INSERT ACTUAL FILE NAME HERE.
                                           #
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
      #
      # Set $VERSION according as it is set in the beginning of $THIS_FILE.
      X=$(grep --max-count=1 "VERSION" $THIS_FILE)
      # X="VERSION=YYYY-MM-DD HH:MM"
      # Use command "eval" to set $VERSION.
      eval $X
      #
      echo "Script: $THIS_FILE. Version: $VERSION" > $TEMP_FILE
      echo >>$TEMP_FILE
      #
      # Display text (all lines beginning ("^") with $2 but do not print $2).
      # sed substitutes null for $2 at the beginning of each line
      # so it is not printed.
      sed -n "s/$2//"p $THIS_DIR/$THIS_FILE >> $TEMP_FILE
      #
      case $3 in
           "NOK" | "nok")
              f_message $1 "NOK" "Message" $TEMP_FILE $4
           ;;
           *)
              f_message $1 "OK" "(use arrow keys to scroll up/down/side-ways)" $TEMP_FILE
           ;;
      esac
      #
} # End of function f_display_common.
#
# +------------------------------+
# |  Function f_msg_txt_file_ok  |
# +------------------------------+
#
#     Rev: 2020-04-22
#  Inputs: $1 - "text", "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - Text string or text file. 
#    Uses: None.
# Outputs: ERROR. 
#
f_msg_txt_file_ok () {
      #
      clear  # Blank the screen.
      #
      # Display text file contents.
      less -P '%P\% (Spacebar, PgUp/PgDn, Up/Dn arrows, press q to quit)' $2
      #
      clear  # Blank the screen.
      #
} # End of function f_msg_txt_file_ok
#
# +----------------------------------------+
# |            Start Main Program          |
# +----------------------------------------+
#
#   Usage: bash file_recursive_rename.sh <TARGET DIRECTORY>
#          bash file_recursive_rename.sh /home/user/Documents
#
#  Inputs: $1=TARGET_DIR
#    Uses: XSTR.
# Outputs: None.
#
clear  # Blank the screen.
#
echo "Running script $THIS_FILE"
echo "***   Rev. $VERSION   ***"
echo
sleep 1  # pause for 1 second automatically.
#
clear # Blank the screen.
#
# Set THIS_DIR, SCRIPT_PATH to directory path of script.
f_script_path
#
# Test for Optional Arguments.
f_arguments $1 $2  # Also sets variable GUI.
#
TSTAMP=$(date --date=now +"%Y-%m-%d_%H%M")
LOG_FILE="file_recursive_rename_$TSTAMP.log"
TEMP_FILE="file_recursive_rename_$TSTAMP.tmp"
REQUIRED_FILE="file_rename.sh"
#
# Put the date stamp in the header of the log file.
echo
echo -n "Script $THIS_FILE" | tee $LOG_FILE
echo -n "Start time: " | tee $LOG_FILE
date | tee -a $LOG_FILE
#
#
if [ -z $1 ] ; then
   echo -n $(tput setaf 1) # Set font to color red.
   echo  | tee -a $LOG_FILE
   echo  "!!!WARNING!!! No target directory was specified." | tee -a $LOG_FILE
   echo  "Usage: bash file_recursive_rename.sh <Target Directory name>" | tee -a $LOG_FILE
   f_abort
fi
#
if [ ! -d $1 ] ; then
   echo -n $(tput setaf 1) # Set font to color red.
   echo | tee -a $LOG_FILE
   echo  "!!!WARNING!!! Cannot continue, \"$1\" directory either does not exist" | tee -a $LOG_FILE
   echo  "or you do not have WRITE permission to the directory: \"$1\"." | tee -a $LOG_FILE
   f_abort
fi
#
if [ ! -r $REQUIRED_FILE ] ; then
   echo -n $(tput setaf 1) # Set font to color red.
   echo | tee -a $LOG_FILE
   echo "!!!WARNING!!! Cannot continue, script \"$REQUIRED_FILE\" either does not exist" | tee -a $LOG_FILE
   echo "or you do not have READ permission to the script: \"$REQUIRED_FILE\"."   echo | tee -a $LOG_FILE
   f_abort
fi
#
# Find all sub-directories under specified directory.
find $1 -type d >$TEMP_FILE
#
# Do not rename files in hidden directories.
# Filter out any hidden directory names from the list of directories
# to be processed.
TEMP_FILE2="file_recursive_rename2_$TSTAMP.tmp"
grep --invert-match -F "/." $TEMP_FILE > $TEMP_FILE2
mv $TEMP_FILE2 $TEMP_FILE
#
echo >> $LOG_FILE
echo "List of Directories for file renaming." >> $LOG_FILE
echo "--------------------------------------" >> $LOG_FILE
cat $TEMP_FILE >>$LOG_FILE
echo "--------------------------------------" >> $LOG_FILE
echo "End of List of Directories">> $LOG_FILE
echo >> $LOG_FILE
#
while read XSTR
do
      echo "Rename files in $XSTR"
      echo
      bash file_rename.sh $XSTR
      echo
      echo
      echo "--------------------------------------------"
      echo
      echo
done < $TEMP_FILE
#
# Find the name of any files that were renamed and append that excerpt to LOG_FILE.
grep renamed file_rename*.log >> $LOG_FILE
#
# List log files for each sub-directory in a temporary file.
ls -l file_rename*.log >$TEMP_FILE
#
# Display list of log files for each sub-directory.
# Detect installed file viewer.
RUNAPP=0
for FILEVR in most more less
    do
    if [ $RUNAPP -eq 0 ] ; then
       type $FILEVR >/dev/null 2>&1  # Test if $FILEVR application is installed.
       ERROR=$?
       if [ $ERROR -eq 0 ] ; then
          $FILEVR $TEMP_FILE
          RUNAPP=1
       fi
    fi
    done
unset RUNAPP FILEVR
# Record finish time in log file.
echo | tee -a $LOG_FILE
echo -n "Script $THIS_FILE Finish time: " | tee -a $LOG_FILE
date | tee -a $LOG_FILE
#
# Ask user to delete old log files.
echo
echo "The detailed log files are not necessary, a comprehensive list"
echo "of renaming actions are recorded in log \"$LOG_FILE\"."
echo
echo -n "Delete detailed log files of actions in each directory (Y/n)? " ; read X
case $X in
     [Nn] | [Nn][Oo])
     echo
     echo "Detailed log files were not deleted."
     echo
     ;;
     *)
     # Delete log files.
     rm file_rename*.log
     echo
     echo "Detailed log files were deleted."
     echo
     ;;
esac
#
# Display LOG_FILE.
#
clear  # blank the screen.
#
echo "Display the log file: $LOG_FILE" ; 
echo
echo "Press \"Enter\" key to continue." ; read X
echo
#
f_msg_txt_file_ok $1 $LOG_FILE
#
# Ask user to delete log files.
echo -n "Delete current log file of actions (Y/n)? " ; read X
case $X in
     [Nn] | [Nn][Oo])
     echo
     echo "Current log file was not deleted."
     echo
     ;;
     *)
     # Delete TEMP file.
     rm $LOG_FILE
     echo
     echo "Current log file was deleted."
     echo
     ;;
esac
#
# Remove Temporary file.
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
# All Dun Dun noodles.
