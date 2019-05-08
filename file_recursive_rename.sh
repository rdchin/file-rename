#!/bin/bash
#
VERSION="2019-05-08 17:17"
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
#@ 2019-05-08 *Initial release.
#@ 
#
# +----------------------------------------+
# |            Function f_abort            |
# +----------------------------------------+
#
#  Inputs: LOG_FILE.
#    Uses: None.
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
LOG_FILE="file_recursive_rename.log"
TEMP_FILE="file_recursive_rename.tmp"
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
echo | tee -a $LOG_FILE
#
find $1 -type d >$TEMP_FILE
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
# Remove Temporary file.
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
# Find the name of any files that were renamed and append that excerpt to LOG_FILE.
grep renamed file_rename*.log >> $LOG_FILE
#
# Delete log files. 
rm file_rename*.log
#
echo | tee -a $LOG_FILE
echo -n "Script $THIS_FILE Finish time: " | tee -a $LOG_FILE
date | tee -a $LOG_FILE
#
# All Dun Dun noodles.
