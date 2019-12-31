#!/bin/bash
#
VERSION="2019-12-31 17:01"
THIS_FILE="file_recursive_rename.sh"
#
#   Usage: bash file_recursive_rename.sh <TARGET DIRECTORY>
#          bash file_recursive_rename.sh /home/user/Documents
#
# Summary:
#
# This script will recursively rename files in the specified directory
# and any sub-directories to enforce standard file naming conventions.
#
# Files in hidden directories are excluded and are not renamed.
#
# If you save articles from web pages as PDF files and use the title 
# of the article as the PDF file name, you will probably end up with
# various punctuation marks in your file name which are incompatible
# or undesirable for any given Operating System (i.e. Unix, Linux,
# Microsoft, Apple, Android).
#
# Such file names derived from article titles often will contain
# punctuation marks such as "?", "!", "/", "&", "%".
#
# This script was written to enforce some of the file naming conventions
# to ensure inter-Operating System compatibility.
#
# It does not enforce all common file naming conventions, but only some
# of the more common ones. See comments below for comprehensive list.
#
# You may easily add more naming conventions in the "Start Main Program"
# section of the script using the existing code as a template.
# 
# 
#
#@ CODE HISTORY
#@
#@ 2019-12-31 *Main Program excluded hidden directories from file
#@             renaming process.
#@
#@ 2019-05-10 *Main Program included time-stamp in log file names.
#@            *Main Program added deletion of temporary files and 
#@             unneeded
#2             log files.
#@
#@ 2019-05-08 *Initial release.
#@ 
#
# +----------------------------------------+
# |            Function f_abort            |
# +----------------------------------------+
#
#  Inputs: LOG_FILE.
#    Uses: RUNAPP, TEMP_FILE, FILEVR, X.
# Outputs: None.
#
f_abort() {
      echo $(tput setaf 1) # Set font to color red.
      echo >&2 "***************" |  tee -a $LOG_FILE*
      echo >&2 "*** ABORTED ***" |  tee -a $LOG_FILE*
      echo >&2 "***************" |  tee -a $LOG_FILE*
      echo |  tee -a $LOG_FILE*
      echo "An error occurred. Exiting..." >&2 |  tee -a $LOG_FILE*
      exit 1
      echo -n $(tput sgr0) # Set font to normal color.
} # End of function f_abort
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
#
TSTAMP=$(date --date=now +"%Y-%m-%d_%H%M")
LOG_FILE="file_recursive_rename_$TSTAMP.log"
TEMP_FILE="file_recursive_rename_$TSTAMP.tmp"
REQUIRED_FILE="file_rename.sh"
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
   echo "!!!WARNING!!! Cannot continue, \"$1\" directory either does not exist"
   echo "or you do not have WRITE permission to the directory: \"$1\"."
   f_abort
fi
#
if [ ! -r $REQUIRED_FILE ] ; then
   echo
   echo -n $(tput setaf 1) # Set font to color red.
   echo "!!!WARNING!!! Cannot continue, script \"$REQUIRED_FILE\" either does not exist"
   echo "or you do not have READ permission to the script: \"$REQUIRED_FILE\"."
   f_abort
fi
#
echo -n "Script $THIS_FILE Start time: " | tee $LOG_FILE
date | tee -a $LOG_FILE
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
# Remove Temporary file.
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
# All Dun Dun noodles.
