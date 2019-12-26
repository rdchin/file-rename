#!/bin/bash
#
VERSION="2019-12-26 11:17"
#
#   Usage: bash file_rename.sh <TARGET DIRECTORY>
#          bash file_rename.sh /home/user/Documents
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
#@ 2019-12-26 *Main Program, f_check_command_rename added check for 
#@             availability of "rename" command, if not then install it. 
#@
#@ 2019-05-08 *Main Program added directory name to the log file.
#@            *Main Program changed name of the log file
#@             From: file_rename_<YYYYMMDD-HHMM>
#@               To: file_rename_<YYYYMMDD-HHMM.SSNNNNNNNNN>.
#@            *Main Program unset LOG_FILE at end of script.
#@
#@ 2019-04-29 *Main Program deleted substitution of strings containing
#@             forward-slash or back-slash to prevent file directory corruption.
#@
#@ 2019-04-08 *Main Program added more substitution strings.
#@
#@ 2018-06-28 *Main Program added the "-verbose" option to the "rename" command
#@             "rename -verbose 's/search-string/replacement-string/g'
#@                     $1/* |  tee -a $LOG_FILE".
#@
#@ 2018-06-07 *Rewrote script to use the rename command with a wild card
#@             for the filename. It is much faster than using
#@             "find -exec rename".
#@             Change from:
#@             find -H [directory] [-maxdepth 1] -type f
#@                  -exec rename -v "s/$1/$2/g" {} \;  | tee -a $LOG_FILE
#@             Change to:
#@             rename 's/search-string/replacement-string/g' $1/*
#@                    |  tee -a $LOG_FILE
#@
#@ 2017-03-10 *Main Program, added script title and version comment.
#@
#@ 2017-03-07 *Main Program, added comment to banner to indicate
#@             step # of process.
#@
#@ 2016-12-27 *Main Program added date/time stamp to file name of log file.
#@            *Main Program, f_find_and_delete, f_find_and_replace
#@             added command options passed to find and rename commands.
#@
#@ 2016-12-07 *f_find_and_delete, f_find_and_replace use one find command.
#@             Used the rename -v option to log verbosely.
#@            *Main Program added find and replace items and added an
#@             option to quit before any files are renamed.
#@            *f_banner simplified format of displayed messages.
#@
#@ 2016-12-06 *f_find_and_delete, f_find_and_replace used two find commands,
#@             the first one to log the action and the second to take action.
#@
#@ 2016-12-04 *Main Program, f_find_and_delete, f_find_and_replace deleted
#@             test simulation feature and add recursive sub-folder renaming.
#@
#@ 2016-10-11 *Main Program comment corrected replacing <colon><space> with
#@             <two-dashes>.
#@            *Main Program Correct order of replacements.
#@             First  "Replace <colon><space> with <two-dashes> in file name"
#@             Second "Replace <colon> with <underscore> in file name."
#@             Third  "Replace <space> with <underscore> in file name."
#@            *f_abort, f_press_enter_key_to_continue added.
#@            *Main Program added check if a target directory was specified and exists.
#@ 
#@ 2016-08-22 *Main Program added replace <colon><space> with <two-dashes>.
#@             Deleted replace <colon> with <underscore>.
#@
#@ 2016-07-20 *Initial release.
#@ 
# +----------------------------------------+
# |            Function f_banner           |
# +----------------------------------------+
#
#  Inputs: $1=String, LOG_FILE.
#    Uses: None.
# Outputs: None.
#
f_banner () {
      BANNER=$1
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
# |      Function f_check_command_rename   |
# +----------------------------------------+
#
#  Inputs: $1=String, LOG_FILE.
#    Uses: None.
# Outputs: None.
#
f_check_command_rename () {
      # Is command "rename" installed and available?
      # Use "command -v" to determine if "rename" is installed and available?
      command -v rename >/dev/null
      # "&>/dev/null" does not work in Debian distro.
      # 1=standard messages, 2=error messages, &=both.
      ERROR=$?
      #
      # Is the "rename" command installed and available?
      if [ $ERROR -eq 0 ] ; then
         rename 's/$/.txt/' $FSDN_FILE"_"*  # Add *.txt file extension.
      else
         # No, the "rename" command is not installed, so install command "rename".
         sudo apt install rename
      fi
} # End of function f_check_command_rename
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
#   Usage: bash file_rename.sh <TARGET DIRECTORY>
#          bash file_rename.sh /home/user/Documents
#
#  Inputs: $1=TARGET_DIR
#    Uses: None.
# Outputs: None.
#
#
# Is the command "rename" available?
f_check_command_rename
#
LOG_FILE="file_rename_$(date +%Y%m%d-%H%M.%S%N).log"
#
# Create date stamp header for log file.
echo -n "Start time for renaming files in directory $1: " | tee $LOG_FILE
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
# # pound         --DONE      < left angle bracket  --DONE      $ dollar sign       --DONE      + plus sign  --DONE
# % percent       --DONE      > right angle bracket --DONE      ! exclamation point --DONE      ` backtick   --DONE
# & ampersand     --DONE      * asterisk            --DONE      ' single quotes     --DONE      | pipe       --DONE
# { left bracket  --DONE      ? question mark       --DONE      " double quotes     --DONE      = equal sign --DONE
# } right bracket --DONE      / forward slash       (NEVER)     : colon             --DONE
# \ back slash    (NEVER)      blank spaces         --DONE      @ at sign           --DONE
#
# The order of operations below is important especially for the "find and replace" operations.
#
# 1. Replace <colon><space> with <two-dashes> in file name.
f_banner "33 of 33 Replace <colon><space> with <two-dashes> in $1/file name."
rename -verbose 's/: /--/g' $1/* |  tee -a $LOG_FILE
#
# 2. Replace <colon> with <underscore> in file name.
f_banner "32 of 33 Replace <colon> with <underscore> in $1/file name."
rename -verbose 's/:/_/g' $1/* |  tee -a $LOG_FILE
#
# 3. Replace <space> with <underscore> in file name.
f_banner "31 of 33 Replace <space> with <underscore> in $1/file name."
rename -verbose 's/ /_/g' $1/* |  tee -a $LOG_FILE
#
# 4. Replace <double-dash> with <two-dashes> in file name.
f_banner "30 of 33 Replace <double-dash> with <two-dashes> in $1/file name."
rename -verbose 's/—/--/g' $1/* |  tee -a $LOG_FILE
#
# 5. Remove <exclamation-mark> in file name.
f_banner "29 of 33 Remove <exclamation-mark> in $1/file name."
rename -verbose 's/!//g' $1/* |  tee -a $LOG_FILE
#
# 6. Remove <question-mark> in file name.
f_banner "28 of 33 Remove <question-mark> in $1/file name."
rename -verbose 's/\?//g' $1/* |  tee -a $LOG_FILE
#
# 7. Remove <percent-sign> in file name.
f_banner "27 of 33 Remove <percent-sign> in $1/file name."
rename -verbose 's/%//g' $1/* |  tee -a $LOG_FILE
#
# 8. Remove <ampersand> in file name.
f_banner "26 of 33 Remove <ampersand> in $1/file name."
rename -verbose 's/\&//g' $1/* |  tee -a $LOG_FILE
#
# 9. Remove <single-quote> in file name.
f_banner "25 of 33 Remove <single-quote> in $1/file name."
rename "s/\'//g" $1/* |  tee -a $LOG_FILE
#
# 10. Remove <single-right-quote> in file name.
f_banner "24 of 33 Remove <single-right-quote> in $1/file name."
rename -verbose 's/’//g' $1/* |  tee -a $LOG_FILE
#
# 11. Remove <double-quote> in file name.
f_banner "23 of 33 Remove <double-quote> in $1/file name."
rename -verbose 's/\"//g' $1/* |  tee -a $LOG_FILE
#
# 12. Remove <right-double-quote> in file name.
f_banner "22 of 33 Remove <right-double-quote> in $1/file name."
rename -verbose 's/”//g' $1/* |  tee -a $LOG_FILE
#
# 13. Remove <left-double-quote> in file name.
f_banner "21 of 33 Remove <left-double-quote> in $1/file name."
rename -verbose 's/“//g' $1/* |  tee -a $LOG_FILE
#
# 14. Replace <underscore-period>  with <period> in file name.
f_banner "20 of 33 Replace <underscore-period>  with <period> in $1/file name."
rename -verbose 's/_\././g' $1/* |  tee -a $LOG_FILE
#
# 15. Replace <triple-underscore> with <underscore> in file name.
f_banner "19 of 33 Replace <triple-underscore> with <underscore> in $1/file name."
rename -verbose 's/___/_/g' $1/* |  tee -a $LOG_FILE
# 
# 16. Replace <double-underscore> with <underscore> in file name.
f_banner "18 of 33 Replace <double-underscore> with <underscore> in $1/file name."
rename -verbose 's/__/_/g' $1/* |  tee -a $LOG_FILE
#
# 17. Repeat Replace <double-underscore> with <underscore> in file name.
f_banner "17 of 33 Repeat Replace <double-underscore> with <underscore> in $1/file name."
rename -verbose 's/__/_/g' $1/* |  tee -a $LOG_FILE
#
# 18. Replace <two-dashes><underscore> with <two-dashes> in file name.
f_banner "16 of 33 Replace <two-dashes><underscore> with <two-dashes> in $1/file name."
rename -verbose 's/--_/--/g' $1/* |  tee -a $LOG_FILE
#
# 19. Replace <underscore><two-dashes> with <two-dashes> in file name.
f_banner "15 of 33 Replace <underscore><two-dashes> with <two-dashes> in $1/file name."
rename -verbose 's/_--/--/g' $1/* |  tee -a $LOG_FILE
#
# 20. Remove <right-bracket> in file name.
f_banner "14 of 33 Remove <right-bracket> in $1/file name."
rename -verbose 's/\}//g' $1/* |  tee -a $LOG_FILE
#
# 21. Remove <left-bracket> in file name.
f_banner "13 of 33 Remove <left-bracket> in $1/file name."
rename -verbose 's/\{//g' $1/* |  tee -a $LOG_FILE
#
# 22. NEVER Remove <forward-slash> in file name. It will change directory of file.
f_banner "12 of 33 NEVER Remove <forward-slash> in $1/file name."
#rename -verbose 's/\///g' $1/* |  tee -a $LOG_FILE
#
# 23. NEVER Remove <back-slash> in file name. It will change directory of file.
f_banner "11 of 33 NEVER Remove <back-slash> in $1/file name."
#rename -verbose 's/\\//g' $1/* |  tee -a $LOG_FILE
#
# 24. Remove <right-angle-bracket> in file name.
f_banner "10 of 33 Remove <right-angle-bracket> in $1/file name."
rename -verbose 's/\>//g' $1/* |  tee -a $LOG_FILE
#
# 25. Remove <left-angle-bracket> in file name.
f_banner "09 of 33 Remove <left-angle-bracket> in $1/file name."
rename -verbose 's/\<//g' $1/* |  tee -a $LOG_FILE
#
# 26. Remove <asterisk> in file name.
f_banner "08 of 33 Remove <asterisk> in $1/file name."
rename -verbose 's/\*//g' $1/* |  tee -a $LOG_FILE
#
# 27. Remove <dollar sign> in file name.
f_banner "07 of 33 Remove <dollar sign> in $1/file name."
rename -verbose 's/\$//g' $1/* |  tee -a $LOG_FILE
#
# 28. Remove <at sign> in file name.
f_banner "06 of 33 Remove <at sign> in $1/file name."
rename -verbose 's/\@//g' $1/* |  tee -a $LOG_FILE
#
# 29. Remove <pound sign> in file name.
f_banner "05 of 33 Remove <pound sign> in $1/file name."
rename -verbose 's/\#//g' $1/* |  tee -a $LOG_FILE
#
# 30. Remove <plus sign> in file name.
f_banner "04 of 33 Remove <plus sign> in $1/file name."
rename -verbose 's/\+//g' $1/* |  tee -a $LOG_FILE
#
# 31. Remove <equal sign> in file name.
f_banner "03 of 33 Remove <equal sign> in $1/file name."
rename -verbose 's/\=//g' $1/* |  tee -a $LOG_FILE
#
# 32. Remove <pipe sign> in file name.
f_banner "02 of 33 Remove <pipe sign> in $1/file name."
rename -verbose 's/\!//g' $1/* |  tee -a $LOG_FILE
#
# 33. Remove <back-tick sign> in file name.
f_banner "01 of 31 Remove <back-tick sign> in $1/file name."
rename -verbose 's/\`//g' $1/* |  tee -a $LOG_FILE
#
echo -n "Finish time: " | tee -a $LOG_FILE
date  | tee -a $LOG_FILE
unset LOG_FILE
#
# All Dun Dun noodles.
