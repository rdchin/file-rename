#!/bin/bash
#
VERSION="2017-06-28 13:42"
#
# Summary:
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
#@ 2018-06-28 *Add the "-verbose" option to the "rename" command "rename -verbose 's/search-string/replacement-string/g' $1/* |  tee -a $LOG_FILE".
#@
#@ 2018-06-07 *Rewrote script to use the rename command with a wild card
#@             for the filename. It is much faster than using
#@             "find -exec rename".
#@             Change from:
#@             find -H [directory] [-maxdepth 1] -type f -exec rename -v "s/$1/$2/g" {} \;  | tee -a $LOG_FILE
#@             Change to:
#@             rename 's/search-string/replacement-string/g' $1/* |  tee -a $LOG_FILE
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
#   Usage: bash file_rename.sh <TARGET DIRECTORY>
#          bash file_rename.sh /home/user/Documents
#
#  Inputs: $1=TARGET_DIR
#    Uses: None.
# Outputs: None.
#
#
LOG_FILE="file_rename.log"
LOG_FILE="$(date +%Y%m%d-%H%M)_$LOG_FILE"
#
# Create date stamp header for log file.
echo -n "Start time: " | tee $LOG_FILE
date  | tee -a $LOG_FILE
#
# Compatible file names for most Operating Systems.
#
# Do not use the following characters:
# # pound           < left angle bracket        $ dollar sign           + plus sign
# % percent         > right angle bracket       ! exclamation point     ` backtick
# & ampersand       * asterisk                  ' single quotes         | pipe
# { left bracket    ? question mark             " double quotes         = equal sign
# } right bracket   / forward slash             : colon
# \ back slash      blank spaces                @ at sign
#
# File names must not begin or end with a <space>, <period>, <hyphen>, or <underline>
# File names should be shorter than 31 characters for compatibility with older (1950-1990's) Operating Systems.
# File names should use lower-case characters as most are case-sensitive.
#
# The order of operations below is important especially for the "find and replace" operations.
#
# 1. Replace <colon><space> with <two-dashes> in file name.
f_banner "19 of 19 Replace <colon><space> with <two-dashes> in file name"
rename -verbose 's/: /--/g' $1/* |  tee -a $LOG_FILE
#
# 2. Replace <colon> with <underscore> in file name.
f_banner "18 of 19 Replace <colon> with <underscore> in file name"
rename -verbose 's/:/_/g' $1/* |  tee -a $LOG_FILE
#
# 3. Replace <space> with <underscore> in file name.
f_banner "17 of 19 Replace <space> with <underscore> in file name"
rename -verbose 's/ /_/g' $1/* |  tee -a $LOG_FILE
#
# 4. Replace <double-dash> with <two-dashes> in file name.
f_banner "16 of 19 Replace <double-dash> with <two-dashes> in file name"
rename -verbose 's/—/--/g' $1/* |  tee -a $LOG_FILE
#
# 5. Remove <exclamation-mark> in file name.
f_banner "15 of 19 Remove <exclamation-mark> in file name"
rename -verbose 's/!//g' $1/* |  tee -a $LOG_FILE
#
# 6. Remove <question-mark> in file name.
f_banner "14 of 19 Remove <question-mark> in file name"
rename -verbose 's/\?//g' $1/* |  tee -a $LOG_FILE
#
# 6. Remove <percent-sign> in file name.
f_banner "13 of 19 Remove <percent-sign> in file name"
rename -verbose 's/%//g' $1/* |  tee -a $LOG_FILE
#
# 6. Remove <ampersand> in file name.
f_banner "12 of 19 Remove <ampersand> in file name"
rename -verbose 's/\&//g' $1/* |  tee -a $LOG_FILE
#
# 7. Remove <single-quote> in file name.
f_banner "11 of 19 Remove <single-quote> in file name"
rename "s/\'//g" $1/* |  tee -a $LOG_FILE
#
# 8. Remove <single-right-quote> in file name.
f_banner "10 of 19 Remove <single-right-quote> in file name"
rename -verbose 's/’//g' $1/* |  tee -a $LOG_FILE
#
# 9. Remove <double-quote> in file name.
f_banner "09 of 19 Remove <double-quote> in file name"
rename -verbose 's/\"//g' $1/* |  tee -a $LOG_FILE
#
# 10. Remove <right-double-quote> in file name.
f_banner "08 of 19 Remove <right-double-quote> in file name"
rename -verbose 's/”//g' $1/* |  tee -a $LOG_FILE
#
# 11. Remove <left-double-quote> in file name.
f_banner "07 of 19 Remove <left-double-quote> in file name"
rename -verbose 's/“//g' $1/* |  tee -a $LOG_FILE
#
# 12. Replace <underscore-period>  with <period> in file name.
f_banner "06 of 19 Replace <underscore-period>  with <period> in file name"
rename -verbose 's/_\././g' $1/* |  tee -a $LOG_FILE
#
# 13. Replace <triple-underscore> with <underscore> in file name.
f_banner "05 of 19 Replace <triple-underscore> with <underscore> in file name"
rename -verbose 's/___/_/g' $1/* |  tee -a $LOG_FILE
# 
# 14. Replace <double-underscore> with <underscore> in file name.
f_banner "04 of 19 Replace <double-underscore> with <underscore> in file name"
rename -verbose 's/__/_/g' $1/* |  tee -a $LOG_FILE
#
# 15. Repeat Replace <double-underscore> with <underscore> in file name.
f_banner "03 of 19 Repeat Replace <double-underscore> with <underscore> in file name"
rename -verbose 's/__/_/g' $1/* |  tee -a $LOG_FILE
#
# 16. Replace <two-dashes><underscore> with <two-dashes> in file name.
f_banner "02 of 19 Replace <two-dashes><underscore> with <two-dashes> in file name."
rename -verbose 's/--_/--/g' $1/* |  tee -a $LOG_FILE
#
# 17. Replace <underscore><two-dashes> with <two-dashes> in file name.
f_banner "01 of 19 Replace <underscore><two-dashes> with <two-dashes> in file name."
rename -verbose 's/_--/--/g' $1/* |  tee -a $LOG_FILE
#
echo -n "Finish time: " | tee -a $LOG_FILE
date  | tee -a $LOG_FILE
