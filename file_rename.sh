#!/bin/bash
#
VERSION="2017-03-10 01:47"
#
#@ CODE HISTORY
#@
#@ 2017-03-10 *Main Program, added script title and version comment.
#@
#@ 2017-03-07 *Main Program, added comment to banner to indicate
#@             step # of process.
#@
#@ 2016-12-27 *Added date/time stamp to file name of log file.
#@            *Main Program, f_find_and_delete, f_find_and_replace
#@             added command options passed to find and rename commands.
#@
#@ 2016-12-07 *f_find_and_delete, f_find_and_replace use one find command.
#@             Used the rename -v option to log verbosely.
#@            *Main Program added find and replace items and added an
#@             option to quit before any files are renamed.
#@            *f_banner simplify format of displayed messages.
#@
#@ 2016-12-06 *f_find_and_delete, f_find_and_replace used two find commands,
#@             the first one to log the action and the second to take action.
#@
#@ 2016-12-04 *Main program, f_find_and_delete, f_find_and_replace deleted
#@             test simulation feature and add recursive sub-folder renaming.
#@
#@ 2016-10-11 *Comment corrected replacing <colon><space> with <two-dashes>.
#@            *Correct order of replacements.
#@             First  "Replace <colon><space> with <two-dashes> in file name"
#@             Second "Replace <colon> with <underscore> in file name."
#@             Third  "Replace <space> with <underscore> in file name."
#@            *Added f_abort, f_press_enter_key_to_continue.
#@            *Added check if a target directory was specified and exists.
#@ 
#@ 2016-08-22 *Added replace <colon><space> with <two-dashes>.
#@             Deleted replace <colon> with <underscore>.
#@
#@ 2016-07-20 *Initial release.
#@ 
# +----------------------------------------+
# |            Function f_banner           |
# +----------------------------------------+
#
#  Inputs: $1=String.
#    Uses: None.
# Outputs: None.
#
f_banner () {
      BANNER=$1
      if [ "$SIM" = 1 ] ; then 
         BANNER="Simulate $1"
      fi
      echo | tee -a $LOG_FILE
      echo "   $BANNER" | tee -a $LOG_FILE
      echo -n "   Start time: " | tee -a $LOG_FILE
      date | tee -a $LOG_FILE
}
# End of function f_banner
#
# +----------------------------------------+
# |        Function find_and_delete        |
# +----------------------------------------+
#
#  Inputs: $1=Find string (to delete).
#          $2=TARGET_DIR.
#          $3=find options.
#          $4=find options.
#          $5=rename options.
#          LOG_FILE.
#    Uses: None.
# Outputs: None.
#
f_find_and_delete () {
      find -H $2 $3 $4 -type f -exec rename -v $5 "s/$1//g" {} \;  | tee -a $LOG_FILE
} # End of function f_find_and_delete
#
# +----------------------------------------+
# |        Function find_and_replace       |
# +----------------------------------------+
#
#  Inputs: $1=Find string.
#          $2=Replacement string.
#          $3=TARGET_DIR
#          $4=find options.
#          $5=find options.
#          $6=rename options.
#          LOG_FILE.
#    Uses: None.
# Outputs: None.
#
f_find_and_replace () {
      find -H $3 $4 $5 -type f -exec rename -v $6 "s/$1/$2/g" {} \;  | tee -a $LOG_FILE
      #
      # find -H $3 -type f -exec rename -n "s/$1/$2/g" {} \; | tee -a $LOG_FILE  # -n no action by rename.
      # find -H $3 -type f -exec rename "s/$1/$2/g" {} \; 2>&1 | tee -a $LOG_FILE  # log only errors.
} # End of function f_find_and_replace
#
# +----------------------------------------+
# | Function f_press_enter_key_to_continue |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: X.
# Outputs: None.
#
f_press_enter_key_to_continue () { # Display message and wait for user input.
      echo
      echo -n "Press '"Enter"' key to continue."
      read X
      unset X  # Throw out this variable.
      #
} # End of function f_press_enter_key_to_continue
#
# +----------------------------------------+
# |            Function f_abort            |
# +----------------------------------------+
#
#  Inputs: None.
#    Uses: None.
# Outputs: None.
#
f_abort() {
      echo $(tput setaf 1) # Set font to color red.
      echo >&2 "***************"
      echo >&2 "*** ABORTED ***"
      echo >&2 "***************"
      echo
      echo "An error occurred. Exiting..." >&2
      exit 1
      echo -n $(tput sgr0) # Set font to normal color.
} # End of function f_abort
#
# +----------------------------------------+
# |            Start Main Program          |
# +----------------------------------------+
#
#   Usage: bash file_rename.sh <TARGET DIRECTORY>
#          bash file_rename.sh /home/user/Documents
#
#  Inputs: $1=TARGET_DIR
#    Uses: None.
# Outputs: None.
#
#
# Note: The rename command with the -n option prevents actual renaming of files
#      in order to perform a test simulation.
# Do a test simulation of the find-rename command.
# find . -type f -exec rename -n 's/\ /\_/g' {} \; | tee -a $LOG_FILE
#
# Remove the "-n" option to perform the actual renaming of files.
# find . -type f -exec rename 's/\ /\_/g' {} \; | tee -a $LOG_FILE
#
LOG_FILE="file_rename.log"
LOG_FILE="$(date +%Y%m%d-%H%M)_$LOG_FILE"
#
if [ -z $1 ] ; then
   echo
   echo "!!!WARNING!!! No target directory was specified."
   echo "Usage: bash file_rename.sh <Target Directory name>"
   echo
   echo -n $(tput setaf 1) # Set font to color red.
   f_abort
fi
#
if [ ! -d $1 ] ; then
   echo
   echo -n $(tput setaf 1) # Set font to color red.
   echo "!!!WARNING!!! Cannot continue, $1 directory either does not exist"
   echo "or you do not have WRITE permission to the directory: $1."
   f_abort
fi
#
TARGET_DIR=$1
#
# clear # Blank the screen.
#
SIM=""
ROPTIONS=""
#
while [  "$SIM" != "1" -a "$SIM" != "0" ]
      do
         echo "Script: file_rename ver. $VERSION"
         echo
         echo -n "Do you wish to do a simulation of renaming files? y/N/(q)uit: " ; read SIM
         #
         case $SIM in
              [Yy] | [Yy][Ee] | [Yy][Ee][Ss])
              SIM=1
              ROPTIONS="-n"
              ;;
              "" | [Nn] | [Nn][Oo])
              SIM=0
              ;;
              [Qq] | [Qq][Uu] | [Qq][Uu][Ii] | [Qq][Uu][Ii][Tt])
              f_abort
              ;;
         esac
     done
#
RECUR=""
FOPTIONS=""
#
while [  "$RECUR" != "1" -a "$RECUR" != "0" ]
      do
         echo
         echo "Target Directory: $TARGET_DIR"
         echo
         echo -n "Recursively rename all files in sub-folders? (Takes more time) (Y/n/(q)uit: " ; read RECUR
         #
         case $RECUR in
              "" | [Yy] | [Yy][Ee] | [Yy][Ee][Ss])
              RECUR=1
              ;;
              [Nn] | [Nn][Oo])
              RECUR=0
              FOPTIONS="-maxdepth 1"
              ;;
              [Qq] | [Qq][Uu] | [Qq][Uu][Ii] | [Qq][Uu][Ii][Tt])
              f_abort
              ;;
         esac
     done
#
# Create date stamp header for log file.
echo -n "Start time: " | tee $LOG_FILE
date  | tee -a $LOG_FILE
#
# 1. Replace <colon><space> with <two-dashes> in file name.
f_banner "16 of 16 Replace <colon><space> with <two-dashes> in file name"
f_find_and_replace ": " "--" $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 2. Replace <colon> with <underscore> in file name.
f_banner "15 of 16 Replace <colon> with <underscore> in file name"
f_find_and_replace ":" "_" $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 3. Replace <space> with <underscore> in file name.
f_banner "14 of 16 Replace <space> with <underscore> in file name"
f_find_and_replace " " "_" $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 4. Replace <double-dash> with <two-dashes> in file name.
f_banner "13 of 16 Replace <double-dash> with <two-dashes> in file name"
f_find_and_replace "—" "--" $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 5. Remove <exclamation-mark> in file name.
f_banner "12 of 16 Remove <exclamation-mark> in file name"
f_find_and_delete "!" $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 6. Remove <question-mark> in file name.
f_banner "11 of 16 Remove <question-mark> in file name"
f_find_and_delete "\?" $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 7. Remove <single-quote> in file name.
f_banner "10 of 16 Remove <single-quote> in file name"
f_find_and_delete "'" $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 8. Remove <single-right-quote> in file name.
f_banner "9 of 16 Remove <single-right-quote> in file name"
f_find_and_delete "’" $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 9. Remove <double-quote> in file name.
f_banner "8 of 16 Remove <double-quote> in file name"
f_find_and_delete "\"" $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 10. Remove <right-double-quote> in file name.
f_banner "7 of 16 Remove <right-double-quote> in file name"
f_find_and_delete "”" $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 11. Remove <left-double-quote> in file name.
f_banner "6 of 16 Remove <left-double-quote> in file name"
f_find_and_delete "“" $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 12. Replace <underscore-period>  with <period> in file name.
f_banner "5 of 16 Replace <underscore-period>  with <period> in file name"
f_find_and_replace "_\." "." $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 13. Replace <triple-underscore> with <underscore> in file name.
f_banner "4 of 16 Replace <triple-underscore> with <underscore> in file name"
f_find_and_replace "___" "_" $TARGET_DIR $FOPTIONS $ROPTIONS
# 
# 14. Replace <double-underscore> with <underscore> in file name.
f_banner "3 of 16 Replace <double-underscore> with <underscore> in file name"
f_find_and_replace "__" "_" $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 15. Replace <two-dashes><underscore> with <two-dashes> in file name.
f_banner "2 of 16 Replace <two-dashes><underscore> with <two-dashes> in file name."
f_find_and_replace "--_" "--" $TARGET_DIR $FOPTIONS $ROPTIONS
#
# 16. Replace <underscore><two-dashes> with <two-dashes> in file name.
f_banner "1 of 16 Replace <underscore><two-dashes> with <two-dashes> in file name."
f_find_and_replace "_--" "--" $TARGET_DIR $FOPTIONS $ROPTIONS
#
echo -n "Finish time: " | tee -a $LOG_FILE
date  | tee -a $LOG_FILE
