#!/bin/bash
#
# ©2024 Copyright 2024 Robert D. Chin
# Email: RDevChin@Gmail.com
#
#   Usage: bash file_rename.sh <TARGET DIRECTORY>
#          bash file_rename.sh <TARGET DIRECTORY> dialog/whiptail/text
#          bash file_rename.sh /home/user/Documents
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program. If not, see <https://www.gnu.org/licenses/>.
#
# +--------------------------------------------------------------------------+
# |                                                                          |
# |                 Customize Menu choice options below.                     |
# |                                                                          |
# +--------------------------------------------------------------------------+
#
#  Format: <#@@> <Menu Option> <#@@> <Description of Menu Option> <#@@> <Corresponding function or action or cammand>
# WARNING: Text strings cannot include apostrophes (').
#
#@@Exit#@@Exit this menu.#@@break
#
#@@Rename Files#@@Rename files to standards.#@@f_main_start^$GUI
#
#@@View Log Files#@@View the log file.#@@f_view_logs^$GUI
#
#@@About#@@Version information of this script.#@@f_about^$GUI
#
#@@Code History#@@Display code change history of this script.#@@f_code_history^$GUI
#
#@@Version Update#@@Check for updates to this script and download.#@@f_check_version^$GUI
#
#@@Help#@@Display help message.#@@f_help_message^$GUI
#
# +----------------------------------------+
# |        Default Variable Values         |
# +----------------------------------------+
#
VERSION="2024-01-20 22:30"
THIS_FILE=$(basename $0)
TEMP_FILE=$THIS_FILE"_temp.txt"
#
#
#================================================================
# EDIT THE LINES BELOW TO SET REPOSITORY SERVERS AND DIRECTORIES
# AND TO INCLUDE ALL DEPENDENT SCRIPTS AND LIBRARIES TO DOWNLOAD.
#================================================================
#
#
#--------------------------------------------------------------
# Set variables to mount the Local Repository to a mount-point.
#--------------------------------------------------------------
#
# LAN File Server shared directory.
# SERVER_DIR="[FILE_SERVER_DIRECTORY_NAME_GOES_HERE]"
  SERVER_DIR="//scotty/files"
#
# Local PC mount-point directory.
# MP_DIR="[LOCAL_MOUNT-POINT_DIRECTORY_NAME_GOES_HERE]"
  MP_DIR="/mnt/scotty/files"
#
# Local PC mount-point with LAN File Server Local Repository full directory path.
# Example:
#                   File server shared directory is "//file_server/public".
# Repostory directory under the shared directory is "scripts/BASH/Repository".
#                 Local PC Mount-point directory is "/mnt/file_server/public".
#
# LOCAL_REPO_DIR="$MP_DIR/[DIRECTORY_PATH_TO_LOCAL_REPOSITORY]"
  LOCAL_REPO_DIR="$MP_DIR/LIBRARY/PC-stuff/PC-software/BASH_Scripting_Projects/Repository"
#
#
#=================================================================
# EDIT THE LINES BELOW TO SPECIFY THE FILE NAMES TO UPDATE.
# FILE NAMES INCLUDE ALL DEPENDENT SCRIPTS LIBRARIES.
#=================================================================
#
#
# --------------------------------------------
# Create a list of all dependent library files
# and write to temporary file, FILE_LIST.
# --------------------------------------------
#
# Temporary file FILE_LIST contains a list of file names of dependent
# scripts and libraries.
#
FILE_LIST=$THIS_FILE"_file_temp.txt"
#
# Format: [File Name]^[Local/Web]^[Local repository directory]^[web repository directory]
echo "common_bash_function.lib^Local^/mnt/scotty/files/LIBRARY/PC-stuff/PC-software/BASH_Scripting_Projects/Repository^https://raw.githubusercontent.com/rdchin/BASH_function_library/master/"   >> $FILE_LIST
#
# Create a name for a temporary file which will have a list of files which need to be downloaded.
FILE_DL_LIST=$THIS_FILE"_file_dl_temp.txt"
#
# +----------------------------------------+
# |            Brief Description           |
# +----------------------------------------+
#
#& Brief Description
#&
#& This script will rename files in one or more specified directories and
#& to enforce standard file naming conventions.
#&
#& Required scripts: file_rename.sh
#&                   common_bash_function.lib
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
#&   Usage: bash file_rename.sh <TARGET DIRECTORY>
#&          bash file_rename.sh /home/user/Documents
#
# +----------------------------------------+
# |             Help and Usage             |
# +----------------------------------------+
#
#?    Usage: bash file_rename.sh [OPTION]
#?           bash file_rename.sh [Target_Directory] [text/dialog/whiptail]
#?
#? Examples:
#? Rename files in TARGET directory.
#?
#? bash file_rename.sh [Target_Directory] # Run script on target directory.
#? bash file_rename.sh [Target_Directory] dialog.
#? bash file_rename.sh [Target_Directory] whiptail.
#? bash file_rename.sh [Target_Directory] text.
#?
#? bash file_rename.sh --help     # Displays this help message.
#?                     -?
#?
#? bash file_rename.sh --about    # Displays script version.
#?                     --version
#?                     --ver
#?                     -v
#?
#? bash file_rename.sh --history  # Displays script code history.
#?                     --hist
#?
#? Examples using 2 arguments:
#?
#? bash example.sh --hist text
#?                 --ver dialog
#
# +----------------------------------------+
# |                Code Notes              |
# +----------------------------------------+
#
# To disable the [ OPTION ] --update -u to update the script:
#    1) Comment out the call to function fdl_download_missing_scripts in
#       Section "Start of Main Program".
#
# To completely delete the [ OPTION ] --update -u to update the script:
#    1) Delete the call to function fdl_download_missing_scripts in
#       Section "Start of Main Program".
#    2) Delete all functions beginning with "f_dl"
#    3) Delete instructions to update script in Section "Help and Usage".
#
# To disable the Main Menu:
#    1) Comment out the call to function f_menu_main under "Run Main Code"
#       in Section "Start of Main Program".
#    2) Add calls to desired functions under "Run Main Code"
#       in Section "Start of Main Program".
#
# To completely remove the Main Menu and its code:
#    1) Delete the call to function f_menu_main under "Run Main Code" in
#       Section "Start of Main Program".
#    2) Add calls to desired functions under "Run Main Code"
#       in Section "Start of Main Program".
#    3) Delete the function f_menu_main.
#    4) Delete "Menu Choice Options" in this script located under
#       Section "Customize Menu choice options below".
#       The "Menu Choice Options" lines begin with "#@@".
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
## 2024-01-20 *Update copyright 2024.
##
## 2022-04-28 *f_view_logs, f_select_log_file_checklist,
##             f_select_log_file_fselect, f_select_log_file_radiolist added
##             to view log files a variety of different ways.
##
## 2022-04-27 *f_main_start enhanced to allow multiple directories
##             to be selected to recursively rename files within them.
##            *f_view_rename_log added added to allow viewing of
##             multiple log files.
##
## 2022-04-26 *f_main_action adjusted format of header of log file.
##
## 2022-04-20 *fdl_download_missing_scripts fixed bug to prevent downloading
##             from the remote repository if the local repository was
##             unavailable and the script was only in the local repository.
##
## 2022-04-13 *f_main_action added deletion of square brackets, parenthesis.
##
## 2022-04-12 *f_select_dir deleted local copy and now use improved version
##             in Common BASH Function Library (common_bash_function.lib).
##            *f_main_start add final go/nogo question before renaming.
##
## 2021-04-19 *Updated to latest standards with extensive code changes.
##             Now uses common_bash_function.lib and added a Main Menu and
##             ability to download missing files and do a version update.
##
## 2020-08-26 *f_check_command_rename improved messages.
##            *Decision made not to be dependent on library of functions,
##             "common_bash_function.lib" for maximum portability.
##
##
## 2020-08-08 *Updated to latest standards.
##
## 2020-06-27 *f_display_common, f_about, f_code_history, f_help_message
##             rewritten to simplify code.
##
## 2020-06-26 *Main Program added acceptance of 2 arguments.
##            *f_arguments updated to latest standards.
##
## 2020-06-25 *Decision made not to be dependent on library of functions,
##             "common_bash_function.lib" for maximum portability.
##
## 2020-04-28 *Main Program updated to latest standards.
##
## 2020-04-02 *Main Program minor enhancements.
##
## 2019-12-26 *f_check_command_rename added check for availability of
##             "rename" command, if not then install it.
##
## 2019-05-08 *Main Program added directory name to the log file.
##            *Main Program changed name of the log file
##             From: file_rename_<YYYYMMDD-HHMM>
##               To: file_rename_<YYYYMMDD-HHMM.SSNNNNNNNNN>.
##            *Main Program unset LOG_FILE at end of script.
##
## 2019-04-29 *f_main_action deleted substitution of strings containing
##             forward-slash or back-slash to prevent file directory
##             corruption.
##
## 2019-04-08 *f_main_action added more substitution strings.
##
## 2018-06-28 *f_main_action added the "-verbose" option to the "rename"
##             command
##             "rename -verbose 's/search-string/replacement-string/g' $1/*
##             |  tee -a $LOG_FILE".
##
## 2018-06-07 *Rewrote script to use the rename command with a wild card
##             for the filename. It is much faster than using
##             "find -exec rename".
##             Change from:
##             find -H [directory] [-maxdepth 1] -type f
##                  -exec rename -v "s/$1/$2/g" {} \;  | tee -a $LOG_FILE
##             Change to:
##             rename 's/search-string/replacement-string/g' $1/*
##                    |  tee -a $LOG_FILE
##
## 2017-03-10 *Main Program added script title and version comment.
##
## 2017-03-07 *Main Program added comment to banner to indicate
##             step # of process.
##
## 2016-12-27 *Main Program added date/time stamp to file name of log file.
##            *Main Program, f_find_and_delete, f_find_and_replace
##             added command options passed to find and rename commands.
##
## 2016-12-07 *f_find_and_delete, f_find_and_replace use one find command.
##             Used the rename -v option to log verbosely.
##            *Main Program added find and replace items and added an
##             option to quit before any files are renamed.
##            *f_banner simplified format of displayed messages.
##
## 2016-12-06 *f_find_and_delete, f_find_and_replace used two find commands,
##             the first one to log the action, the second to take action.
##
## 2016-12-04 *Main Program, f_find_and_delete, f_find_and_replace deleted
##             test simulation feature, added recursive sub-folder renaming.
##
## 2016-10-11 *Main Program comment corrected replacing <colon><space> with
##             <two-dashes>.
##            *Main Program Correct order of replacements.
##             1. "Replace <colon><space> with <two-dashes> in file name"
##             2. "Replace <colon> with <underscore> in file name."
##             3. "Replace <space> with <underscore> in file name."
##            *f_abort, f_press_enter_key_to_continue added.
##            *Main Program added check if a target directory was specified
##             and exists.
##
## 2016-08-22 *Main Program added replace <colon><space> with <two-dashes>.
##             Deleted replace <colon> with <underscore>.
##
## 2016-07-20 *Initial release.
#
# +------------------------------------+
# |     Function f_display_common      |
# +------------------------------------+
#
#     Rev: 2021-03-31
#  Inputs: $1=UI - "text", "dialog" or "whiptail" the preferred user-interface.
#          $2=Delimiter of text to be displayed.
#          $3="NOK", "OK", or null [OPTIONAL] to control display of "OK" button.
#          $4=Pause $4 seconds [OPTIONAL]. If "NOK" then pause to allow text to be read.
#          THIS_DIR, THIS_FILE, VERSION.
#    Uses: X.
# Outputs: None.
#
# Synopsis: Display lines of text beginning with a given comment delimiter.
#
# Dependencies: f_message.
#
f_display_common () {
      #
      # Set $THIS_FILE to the file name containing the text to be displayed.
      #
      # WARNING: Do not define $THIS_FILE within a library script.
      #
      # This prevents $THIS_FILE being inadvertently re-defined and set to
      # the file name of the library when the command:
      # "source [ LIBRARY_FILE.lib ]" is used.
      #
      # For that reason, all library files now have the line
      # THIS_FILE="[LIBRARY_FILE.lib]" commented out or deleted.
      #
      #
      #==================================================================
      # EDIT THE LINE BELOW TO DEFINE $THIS_FILE AS THE ACTUAL FILE NAME
      # CONTAINING THE BRIEF DESCRIPTION, CODE HISTORY, AND HELP MESSAGE.
      #==================================================================
      #
      #
      THIS_FILE="file_rename.sh"  # <<<--- INSERT ACTUAL FILE NAME HERE.
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
# +----------------------------------------+
# |        Function f_check_version        |
# +----------------------------------------+
#
#     Rev: 2021-03-25
#  Inputs: $1 - UI "dialog" or "whiptail" or "text".
#          $2 - [OPTIONAL] File name to compare.
#          FILE_TO_COMPARE.
#    Uses: SERVER_DIR, MP_DIR, TARGET_DIR, TARGET_FILE, VERSION, TEMP_FILE, ERROR.
# Outputs: ERROR.
#
# Summary: Check the version of a single, local file or script,
#          FILE_TO_COMPARE with the version of repository file.
#          If the repository file has latest version, then copy all
#          dependent files and libraries from the repository to local PC.
#
# TO DO enhancement: If local (LAN) repository is unavailable, then
#          connect to repository on the web if available.
#
# Dependencies: f_version_compare.
#
f_check_version () {
      #
      #
      #=================================================================
      # EDIT THE LINES BELOW TO DEFINE THE LAN FILE SERVER DIRECTORY,
      # LOCAL MOUNTPOINT DIRECTORY, LOCAL REPOSITORY DIRECTORY AND
      # FILE TO COMPARE BETWEEN THE LOCAL PC AND (LAN) LOCAL REPOSITORY.
      #=================================================================
      #
      #
      # LAN File Server shared directory.
      # SERVER_DIR="[FILE_SERVER_DIRECTORY_NAME_GOES_HERE]"
        SERVER_DIR="//scotty/files"
      #
      # Local PC mount-point directory.
      # MP_DIR="[LOCAL_MOUNT-POINT_DIRECTORY_NAME_GOES_HERE]"
        MP_DIR="/mnt/scotty/files"
      #
      # Local PC mount-point with LAN File Server Local Repository full directory path.
      # Example:
      #                   File server shared directory is "//file_server/public".
      # Repository directory under the shared directory is "scripts/BASH/Repository".
      #                 Local PC Mount-point directory is "/mnt/file_server/public".
      #
      # Local PC mount-point with LAN File Server Local Repository full directory path.
      # LOCAL_REPO_DIR="$MP_DIR/[DIRECTORY_PATH_TO_LOCAL_REPOSITORY]"
        LOCAL_REPO_DIR="$MP_DIR/LIBRARY/PC-stuff/PC-software/BASH_Scripting_Projects/Repository"
      #
      # Local PC file to be compared.
      if [ $# -eq 2 ] ; then
         # There are 2 arguments that have been passed to this function.
         # $2 contains the file name to compare.
         FILE_TO_COMPARE=$2
      else
         # $2 is null, so specify file name.
         if [ -z "$FILE_TO_COMPARE" ] ; then
            # FILE_TO_COMPARE is undefined so specify file name.
            FILE_TO_COMPARE=$(basename $0)
         fi
      fi
      #
      # Version of Local PC file to be compared.
      VERSION=$(grep --max-count=1 "VERSION" $FILE_TO_COMPARE)
      #
      FILE_LIST=$THIS_DIR/$THIS_FILE"_file_temp.txt"
      ERROR=0
      #
      #
      #=================================================================
      # EDIT THE LINES BELOW TO SPECIFY THE FILE NAMES TO UPDATE.
      # FILE NAMES INCLUDE ALL DEPENDENT SCRIPTS AND LIBRARIES.
      #=================================================================
      #
      #
      # Create list of files to update and write to temporary file, FILE_LIST.
      #
      echo "file_rename.sh"            > $FILE_LIST  # <<<--- INSERT ACTUAL FILE NAME HERE.
      echo "common_bash_function.lib" >> $FILE_LIST  # <<<--- INSERT ACTUAL FILE NAME HERE.
      #
      f_version_compare $1 $SERVER_DIR $MP_DIR $LOCAL_REPO_DIR $FILE_TO_COMPARE "$VERSION" $FILE_LIST
      #
      if [ -r  $FILE_LIST ] ; then
         rm  $FILE_LIST
      fi
      #
}  # End of function f_check_version_TEMPLATE.
#
# +----------------------------------------+
# |          Function f_menu_main          |
# +----------------------------------------+
#
#     Rev: 2021-03-07
#  Inputs: $1 - "text", "dialog" or "whiptail" the preferred user-interface.
#    Uses: ARRAY_FILE, GENERATED_FILE, MENU_TITLE.
# Outputs: None.
#
# Summary: Display Main-Menu.
#          This Main Menu function checks its script for the Main Menu
#          options delimited by "#@@" and if it does not find any, then
#          it it defaults to the specified library script.
#
# Dependencies: f_menu_arrays, f_create_show_menu.
#
f_menu_main () { # Create and display the Main Menu.
      #
      GENERATED_FILE=$THIS_DIR/$THIS_FILE"_menu_main_generated.lib"
      #
      # Does this file have menu items in the comment lines starting with "#@@"?
      grep --silent ^\#@@ $THIS_DIR/$THIS_FILE
      ERROR=$?
      # exit code 0 - menu items in this file.
      #           1 - no menu items in this file.
      #               file name of file containing menu items must be specified.
      if [ $ERROR -eq 0 ] ; then
         # Extract menu items from this file and insert them into the Generated file.
         # This is required because f_menu_arrays cannot read this file directly without
         # going into an infinite loop.
         grep ^\#@@ $THIS_DIR/$THIS_FILE >$GENERATED_FILE
         #
         # Specify file name with menu item data.
         ARRAY_FILE="$GENERATED_FILE"
      else
         #
         #
         #================================================================================
         # EDIT THE LINE BELOW TO DEFINE $ARRAY_FILE AS THE ACTUAL FILE NAME (LIBRARY)
         # WHERE THE MENU ITEM DATA IS LOCATED. THE LINES OF DATA ARE PREFIXED BY "#@@".
         #================================================================================
         #
         #
         # Specify library file name with menu item data.
         # ARRAY_FILE="[FILENAME_GOES_HERE]"
           ARRAY_FILE="$THIS_DIR/dummy_file_name.lib"
      fi
      #
      # Create arrays from data.
      f_menu_arrays $ARRAY_FILE
      #
      # Calculate longest line length to find maximum menu width
      # for Dialog or Whiptail using lengths calculated by f_menu_arrays.
      let MAX_LENGTH=$MAX_CHOICE_LENGTH+$MAX_SUMMARY_LENGTH
      #
      # Create generated menu script from array data.
      #
      # Note: ***If Menu title contains spaces,
      #       ***the size of the menu window will be too narrow.
      #
      # Menu title MUST use underscores instead of spaces.
      MENU_TITLE="File_Name_Menu"
      TEMP_FILE=$THIS_DIR/$THIS_FILE"_menu_main_temp.txt"
      #
      f_create_show_menu $1 $GENERATED_FILE $MENU_TITLE $MAX_LENGTH $MAX_LINES $MAX_CHOICE_LENGTH $TEMP_FILE
      #
      if [ -r $GENERATED_FILE ] ; then
         rm $GENERATED_FILE
      fi
      #
      if [ -r $TEMP_FILE ] ; then
         rm $TEMP_FILE
      fi
      #
} # End of function f_menu_main.
#
# +----------------------------------------+
# |  Function fdl_dwnld_file_from_web_site |
# +----------------------------------------+
#
#     Rev: 2021-03-08
#  Inputs: $1=GitHub Repository
#          $2=file name to download.
#    Uses: None.
# Outputs: None.
#
# Summary: Download a list of file names from a web site.
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: wget.
#
#
fdl_dwnld_file_from_web_site () {
      #
      # $1 ends with a slash "/" so can append $2 immediately after $1.
      echo
      echo ">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<"
      echo ">>> Download file from Web Repository <<<"
      echo ">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<"
      echo
      wget --show-progress $1$2
      ERROR=$?
      if [ $ERROR -ne 0 ] ; then
            echo
            echo ">>>>>>>>>>>>>><<<<<<<<<<<<<<"
            echo ">>> wget download failed <<<"
            echo ">>>>>>>>>>>>>><<<<<<<<<<<<<<"
            echo
            echo "Error copying from Web Repository file: \"$2.\""
            echo
      else
         # Make file executable (useable).
         chmod +x $2
         #
         if [ -x $2 ] ; then
            # File is good.
            ERROR=0
         else
            echo
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo ">>> File Error after download from Web Repository <<<"
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo
            echo "$2 is missing or file is not executable."
            echo
         fi
      fi
      #
      # Make downloaded file executable.
      chmod 755 $2
      #
} # End of function fdl_dwnld_file_from_web_site.
#
# +-----------------------------------------------+
# | Function fdl_dwnld_file_from_local_repository |
# +-----------------------------------------------+
#
#     Rev: 2021-03-08
#  Inputs: $1=Local Repository Directory.
#          $2=File to download.
#    Uses: TEMP_FILE.
# Outputs: ERROR.
#
# Summary: Copy a file from the local repository on the LAN file server.
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: None.
#
fdl_dwnld_file_from_local_repository () {
      #
      echo
      echo ">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<"
      echo ">>> File Copy from Local Repository <<<"
      echo ">>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<"
      echo
      eval cp -p $1/$2 .
      ERROR=$?
      #
      if [ $ERROR -ne 0 ] ; then
         echo
         echo ">>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<"
         echo ">>> File Copy Error from Local Repository <<<"
         echo ">>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<"
         echo
         echo -e "Error copying from Local Repository file: \"$2.\""
         echo
         ERROR=1
      else
         # Make file executable (useable).
         chmod +x $2
         #
         if [ -x $2 ] ; then
            # File is good.
            ERROR=0
         else
            echo
            echo ">>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo ">>> File Error after copy from Local Repository <<<"
            echo ">>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo
            echo -e "File \"$2\" is missing or file is not executable."
            echo
            ERROR=1
         fi
      fi
      #
      if [ $ERROR -eq 0 ] ; then
         echo
         echo -e "Successful Update of file \"$2\" to latest version.\n\nScript must be re-started to use the latest version."
         echo "____________________________________________________"
      fi
      #
} # End of function fdl_dwnld_file_from_local_repository.
#
# +-------------------------------------+
# |       Function fdl_mount_local      |
# +-------------------------------------+
#
#     Rev: 2021-03-10
#  Inputs: $1=Server Directory.
#          $2=Local Mount Point Directory
#          TEMP_FILE
#    Uses: TARGET_DIR, UPDATE_FILE, ERROR, SMBUSER, PASSWORD.
# Outputs: ERROR.
#
# Summary: Mount directory using Samba and CIFS and echo error message.
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: Software package "cifs-utils" in the Distro's Repository.
#
fdl_mount_local () {
      #
      # Mount local repository on mount-point.
      # Write any error messages to file $TEMP_FILE. Get status of mountpoint, mounted?.
      mountpoint $2 >/dev/null 2>$TEMP_FILE
      ERROR=$?
      if [ $ERROR -ne 0 ] ; then
         # Mount directory.
         # Cannot use any user prompted read answers if this function is in a loop where file is a loop input.
         # The read statements will be treated as the next null parameters in the loop without user input.
         # To solve this problem, specify input from /dev/tty "the keyboard".
         #
         echo
         read -p "Enter user name: " SMBUSER < /dev/tty
         echo
         read -s -p "Enter Password: " PASSWORD < /dev/tty
         echo sudo mount -t cifs $1 $2
         sudo mount -t cifs -o username="$SMBUSER" -o password="$PASSWORD" $1 $2
         #
         # Write any error messages to file $TEMP_FILE. Get status of mountpoint, mounted?.
         mountpoint $2 >/dev/null 2>$TEMP_FILE
         ERROR=$?
         #
         if [ $ERROR -ne 0 ] ; then
            echo
            echo ">>>>>>>>>><<<<<<<<<<<"
            echo ">>> Mount failure <<<"
            echo ">>>>>>>>>><<<<<<<<<<<"
            echo
            echo -e "Directory mount-point \"$2\" is not mounted."
            echo
            echo -e "Mount using Samba failed. Are \"samba\" and \"cifs-utils\" installed?"
            echo "------------------------------------------------------------------------"
            echo
         fi
         unset SMBUSER PASSWORD
      fi
      #
} # End of function fdl_mount_local.
#
# +------------------------------------+
# |        Function fdl_source         |
# +------------------------------------+
#
#     Rev: 2021-03-25
#  Inputs: $1=File name to source.
# Outputs: ERROR.
#
# Summary: Source the provided library file and echo error message.
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: None.
#
fdl_source () {
      #
      # Initialize ERROR.
      ERROR=0
      #
      if [ -x "$1" ] ; then
         # If $1 is a library, then source it.
         case $1 in
              *.lib)
                 source $1
                 ERROR=$?
                 #
                 if [ $ERROR -ne 0 ] ; then
                    echo
                    echo ">>>>>>>>>><<<<<<<<<<<"
                    echo ">>> Library Error <<<"
                    echo ">>>>>>>>>><<<<<<<<<<<"
                    echo
                    echo -e "$1 cannot be sourced using command:\n\"source $1\""
                    echo
                 fi
              ;;
         esac
         #
      fi
      #
} # End of function fdl_source.
#
# +----------------------------------------+
# |  Function fdl_download_missing_scripts |
# +----------------------------------------+
#
#     Rev: 2021-03-11
#  Inputs: $1 - File containing a list of all file dependencies.
#          $2 - File name of generated list of missing file dependencies.
# Outputs: ANS.
#
# Summary: This function can be used when script is first run.
#          It verifies that all dependencies are satisfied.
#          If any are missing, then any missing required dependencies of
#          scripts and libraries are downloaded from a LAN repository or
#          from a repository on the Internet.
#
#          This function allows this single script to be copied to any
#          directory and then when it is executed or run, it will download
#          automatically all other needed files and libraries, set them to be
#          executable, and source the required libraries.
#
#          Cannot be dependent on "common_bash_function.lib" as this library
#          may not yet be available and may need to be downloaded.
#
# Dependencies: None.
#
fdl_download_missing_scripts () {
      #
      # Delete any existing temp file.
      if [ -r  $2 ] ; then
         rm  $2
      fi
      #
      # ****************************************************
      # Create new list of files that need to be downloaded.
      # ****************************************************
      #
      # While-loop will read the file names listed in FILE_LIST (list of
      # script and library files) and detect which are missing and need
      # to be downloaded and then put those file names in FILE_DL_LIST.
      #
      while read LINE
            do
               FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
               if [ ! -x $FILE ] ; then
                  # File needs to be downloaded or is not executable.
                  # Write any error messages to file $TEMP_FILE.
                  chmod +x $FILE 2>$TEMP_FILE
                  ERROR=$?
                  #
                  if [ $ERROR -ne 0 ] ; then
                     # File needs to be downloaded. Add file name to a file list in a text file.
                     # Build list of files to download.
                     echo $LINE >> $2
                  fi
               fi
            done < $1
      #
      # If there are files to download (listed in FILE_DL_LIST), then mount local repository.
      if [ -s "$2" ] ; then
         echo
         echo "There are missing file dependencies which must be downloaded from"
         echo "the local repository or web repository."
         echo
         echo "Missing files:"
         while read LINE
               do
                  echo $LINE | awk -F "^" '{ print $1 }'
               done < $2
         echo
         echo "You will need to present credentials."
         echo
         echo -n "Press '"Enter"' key to continue." ; read X ; unset X
         #
         #----------------------------------------------------------------------------------------------
         # From list of files to download created above $FILE_DL_LIST, download the files one at a time.
         #----------------------------------------------------------------------------------------------
         #
         while read LINE
               do
                  # Get Download Source for each file.
                  DL_FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
                  DL_SOURCE=$(echo $LINE | awk -F "^" '{ print $2 }')
                  TARGET_DIR=$(echo $LINE | awk -F "^" '{ print $3 }')
                  DL_REPOSITORY=$(echo $LINE | awk -F "^" '{ print $4 }')
                  #
                  # Initialize Error Flag.
                  ERROR=0
                  #
                  # If a file only found in the Local Repository has source changed
                  # to "Web" because LAN connectivity has failed, then do not download.
                  if [ -z $DL_REPOSITORY ] && [ $DL_SOURCE = "Web" ] ; then
                     ERROR=1
                  fi
                  #
                  case $DL_SOURCE in
                       Local)
                          # Download from Local Repository on LAN File Server.
                          # Are LAN File Server directories available on Local Mount-point?
                          fdl_mount_local $SERVER_DIR $MP_DIR
                          #
                          if [ $ERROR -ne 0 ] ; then
                             # Failed to mount LAN File Server directory on Local Mount-point.
                             # So download from Web Repository.
                             fdl_dwnld_file_from_web_site $DL_REPOSITORY $DL_FILE
                          else
                             # Sucessful mount of LAN File Server directory.
                             # Continue with download from Local Repository on LAN File Server.
                             fdl_dwnld_file_from_local_repository $TARGET_DIR $DL_FILE
                             #
                             if [ $ERROR -ne 0 ] ; then
                                # Failed to download from Local Repository on LAN File Server.
                                # So download from Web Repository.
                                fdl_dwnld_file_from_web_site $DL_REPOSITORY $DL_FILE
                             fi
                          fi
                       ;;
                       Web)
                          # Download from Web Repository.
                          fdl_dwnld_file_from_web_site $DL_REPOSITORY $DL_FILE
                          if [ $ERROR -ne 0 ] ; then
                             # Failed so mount LAN File Server directory on Local Mount-point.
                             fdl_mount_local $SERVER_DIR $MP_DIR
                             #
                             if [ $ERROR -eq 0 ] ; then
                                # Successful mount of LAN File Server directory.
                                # Continue with download from Local Repository on LAN File Server.
                                fdl_dwnld_file_from_local_repository $TARGET_DIR $DL_FILE
                             fi
                          fi
                       ;;
                  esac
               done < $2
         #
         if [ $ERROR -ne 0 ] ; then
            echo
            echo
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo ">>> Download failed. Cannot continue, exiting program. <<<"
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo
         else
            echo
            echo
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo ">>> Download is good. Re-run required, exiting program. <<<"
            echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
            echo
         fi
         #
      fi
      #
      # Source each library.
      #
      while read LINE
            do
               FILE=$(echo $LINE | awk -F "^" '{ print $1 }')
               # Invoke any library files.
               fdl_source $FILE
               if [ $ERROR -ne 0 ] ; then
                  echo
                  echo ">>>>>>>>>><<<<<<<<<<<"
                  echo ">>> Library Error <<<"
                  echo ">>>>>>>>>><<<<<<<<<<<"
                  echo
                  echo -e "$1 cannot be sourced using command:\n\"source $1\""
                  echo
               fi
            done < $1
      if [ $ERROR -ne 0 ] ; then
         echo
         echo
         echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
         echo ">>> Invoking Libraries failed. Cannot continue, exiting program. <<<"
         echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
         echo
      fi
      #
} # End of function fdl_download_missing_scripts.
#
# +----------------------------------------+
# |          Function f_main_start         |
# +----------------------------------------+
#
#  Inputs: $1=GUI.
#          THIS_DIR.
#    Uses: None.
# Outputs: TARGET_DIR.
#
# Summary: Display a banner with start times and send to a log file.
#
# Dependencies: None
#
f_main_start () {
     #
      f_select_dir $1 "Select_Directory" $THIS_DIR 0
      DIR_LIST=$ANS
      #
      for SELECT_DIR in $DIR_LIST
          do
             # Set TARGET_DIR to the selected directory.
             # Delete any trailing "/" in directory string.
             TARGET_DIR=$(echo $SELECT_DIR | sed 's|/$||')
             #
             # Start renaming files within TARGET_DIR.
             f_main_action $1 $TARGET_DIR
          done
      #
      # Discard variables.
      unset DIR_LIST SELECT_DIR TARGET_DIR
      #
} # End of function f_main_start.
#
# +----------------------------------------+
# |         Function f_main_action         |
# +----------------------------------------+
#
#  Inputs: $1=GUI
#          $2=TARGET DIRECTORY.
#    Uses: ERROR.
# Outputs: None.
#
# Summary: Rename files, display progress banner.
#
# Dependencies: rename.
#
f_main_action () {
#
LOG_FILE="file_rename_$(date +%Y-%m-%d-%H%M.%S%N).log"
#
# Is the command "rename" available?
f_check_command_rename $1
#
# Blank the screen.
clear
#
# Create date stamp header for log file.
echo "Script $THIS_FILE Renaming files in directory:" | tee $LOG_FILE
echo " $2" | tee -a $LOG_FILE
echo -n " Start time: " | tee -a $LOG_FILE
date | tee -a $LOG_FILE
#
# Compatible file names for most Operating Systems.
#
# Do not use the following characters:
# # pound          < left angle bracket   $ dollar sign        + plus sign
# % percent        > right angle bracket  ! exclamation point  ` backtick
# & ampersand      * asterisk             ' single quotes      | pipe
# { left bracket   ? question mark        " double quotes      = equal sign
# } right bracket  blank spaces           : colon              @ at sign
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
f_banner "33 of 33 Replace <colon><space> with <two-dashes> in $2/file name."
rename -verbose 's/: /--/g' $2/* |  tee -a $LOG_FILE
#
# 2. Replace <colon> with <underscore> in file name.
f_banner "32 of 33 Replace <colon> with <underscore> in $2/file name."
rename -verbose 's/:/_/g' $2/* |  tee -a $LOG_FILE
#
# 3. Replace <space> with <underscore> in file name.
f_banner "31 of 33 Replace <space> with <underscore> in $2/file name."
rename -verbose 's/ /_/g' $2/* |  tee -a $LOG_FILE
#
# 4. Replace <double-dash> with <two-dashes> in file name.
f_banner "30 of 33 Replace <double-dash> with <two-dashes> in $2/file name."
rename -verbose 's/—/--/g' $2/* |  tee -a $LOG_FILE
#
# 5. Remove <exclamation-mark> in file name.
f_banner "29 of 33 Remove <exclamation-mark> in $2/file name."
rename -verbose 's/!//g' $2/* |  tee -a $LOG_FILE
#
# 6. Remove <question-mark> in file name.
f_banner "28 of 33 Remove <question-mark> in $2/file name."
rename -verbose 's/\?//g' $2/* |  tee -a $LOG_FILE
#
# 7. Remove <percent-sign> in file name.
f_banner "27 of 33 Remove <percent-sign> in $2/file name."
rename -verbose 's/%//g' $2/* |  tee -a $LOG_FILE
#
# 8. Remove <ampersand> in file name.
f_banner "26 of 33 Remove <ampersand> in $2/file name."
rename -verbose 's/\&//g' $2/* |  tee -a $LOG_FILE
#
# 9. Remove <single-quote> in file name.
f_banner "25 of 33 Remove <single-quote> in $2/file name."
rename "s/\'//g" $2/* |  tee -a $LOG_FILE
#
# 10. Remove <single-right-quote> in file name.
f_banner "24 of 33 Remove <single-right-quote> in $2/file name."
rename -verbose 's/’//g' $2/* |  tee -a $LOG_FILE
#
# 11. Remove <double-quote> in file name.
f_banner "23 of 33 Remove <double-quote> in $2/file name."
rename -verbose 's/\"//g' $2/* |  tee -a $LOG_FILE
#
# 12. Remove <right-double-quote> in file name.
f_banner "22 of 33 Remove <right-double-quote> in $2/file name."
rename -verbose 's/”//g' $2/* |  tee -a $LOG_FILE
#
# 13. Remove <left-double-quote> in file name.
f_banner "21 of 33 Remove <left-double-quote> in $2/file name."
rename -verbose 's/“//g' $2/* |  tee -a $LOG_FILE
#
# 14. Replace <underscore-period>  with <period> in file name.
f_banner "20 of 33 Replace <underscore-period>  with <period> in $2/file name."
rename -verbose 's/_\././g' $2/* |  tee -a $LOG_FILE
#
# 15. Replace <triple-underscore> with <underscore> in file name.
f_banner "19 of 33 Replace <triple-underscore> with <underscore> in $2/file name."
rename -verbose 's/___/_/g' $2/* |  tee -a $LOG_FILE
#
# 16. Replace <double-underscore> with <underscore> in file name.
f_banner "18 of 33 Replace <double-underscore> with <underscore> in $2/file name."
rename -verbose 's/__/_/g' $2/* |  tee -a $LOG_FILE
#
# 17. Repeat Replace <double-underscore> with <underscore> in file name.
f_banner "17 of 33 Repeat Replace <double-underscore> with <underscore> in $2/file name."
rename -verbose 's/__/_/g' $2/* |  tee -a $LOG_FILE
#
# 18. Replace <two-dashes><underscore> with <two-dashes> in file name.
f_banner "16 of 33 Replace <two-dashes><underscore> with <two-dashes> in $2/file name."
rename -verbose 's/--_/--/g' $2/* |  tee -a $LOG_FILE
#
# 19. Replace <underscore><two-dashes> with <two-dashes> in file name.
f_banner "15 of 33 Replace <underscore><two-dashes> with <two-dashes> in $2/file name."
rename -verbose 's/_--/--/g' $2/* |  tee -a $LOG_FILE
#
# 20. Remove <right-bracket> in file name.
f_banner "14 of 33 Remove <right-bracket> in $2/file name."
rename -verbose 's/\}//g' $2/* |  tee -a $LOG_FILE
#
# 21. Remove <left-bracket> in file name.
f_banner "13 of 33 Remove <left-bracket> in $2/file name."
rename -verbose 's/\{//g' $2/* |  tee -a $LOG_FILE
#
# 22. NEVER Remove <forward-slash> in file name. It will change directory of file.
f_banner "12 of 33 NEVER Remove <forward-slash> in $2/file name."
#rename -verbose 's/\///g' $2/* |  tee -a $LOG_FILE
#
# 23. NEVER Remove <back-slash> in file name. It will change directory of file.
f_banner "11 of 33 NEVER Remove <back-slash> in $2/file name."
#rename -verbose 's/\\//g' $2/* |  tee -a $LOG_FILE
#
# 24. Remove <right-angle-bracket> in file name.
f_banner "10 of 33 Remove <right-angle-bracket> in $2/file name."
rename -verbose 's/\>//g' $2/* |  tee -a $LOG_FILE
#
# 25. Remove <left-angle-bracket> in file name.
f_banner "09 of 33 Remove <left-angle-bracket> in $2/file name."
rename -verbose 's/\<//g' $2/* |  tee -a $LOG_FILE
#
# 26. Remove <asterisk> in file name.
f_banner "08 of 33 Remove <asterisk> in $2/file name."
rename -verbose 's/\*//g' $2/* |  tee -a $LOG_FILE
#
# 27. Remove <dollar sign> in file name.
f_banner "07 of 33 Remove <dollar sign> in $2/file name."
rename -verbose 's/\$//g' $2/* |  tee -a $LOG_FILE
#
# 28. Remove <at sign> in file name.
f_banner "06 of 33 Remove <at sign> in $2/file name."
rename -verbose 's/\@//g' $2/* |  tee -a $LOG_FILE
#
# 29. Remove <pound sign> in file name.
f_banner "05 of 33 Remove <pound sign> in $2/file name."
rename -verbose 's/\#//g' $2/* |  tee -a $LOG_FILE
#
# 30. Remove <plus sign> in file name.
f_banner "04 of 33 Remove <plus sign> in $2/file name."
rename -verbose 's/\+//g' $2/* |  tee -a $LOG_FILE
#
# 31. Remove <equal sign> in file name.
f_banner "03 of 33 Remove <equal sign> in $2/file name."
rename -verbose 's/\=//g' $2/* |  tee -a $LOG_FILE
#
# 32. Remove <pipe sign> in file name.
f_banner "02 of 33 Replace <pipe sign> with <underscore> in $2/file name."
rename -verbose 's/\|/_/g' $2/* |  tee -a $LOG_FILE
#
# 33. Remove <back-tick sign> in file name.
f_banner "01 of 31 Remove <back-tick sign> in $2/file name."
rename -verbose 's/\`//g' $2/* |  tee -a $LOG_FILE
#
# 34. Remove <square brackets> in file name.
rename -verbose 's/\[//g' $2/* |  tee -a $LOG_FILE
rename -verbose 's/\]//g' $2/* |  tee -a $LOG_FILE
#
# 35. Remove <parenthesis> in file name.
rename -verbose 's/\(//g' $2/* |  tee -a $LOG_FILE
rename -verbose 's/\)//g' $2/* |  tee -a $LOG_FILE
#
echo -n "Finish time: " | tee -a $LOG_FILE
date  | tee -a $LOG_FILE
unset LOG_FILE
#
if [ -e $TEMP_FILE ] ; then
   # Remove Temporary file.
   rm $TEMP_FILE
fi
#
} # End of function f_main_action
#
# +----------------------------------------+
# |            Function f_banner           |
# +----------------------------------------+
#
#  Inputs: $1=String, LOG_FILE.
#    Uses: None.
# Outputs: None.
#
# Summary: Display a banner with start times and send to a log file.
#
# Dependencies: None
#
f_banner () {
     #
      BANNER=$1
      # Comment out to speed up script execution.
      #echo | tee -a $LOG_FILE
      #echo "   $BANNER" | tee -a $LOG_FILE
      #echo -n "   Start time: " | tee -a $LOG_FILE
      #date | tee -a $LOG_FILE
      #
}
# End of function f_banner
#
# +----------------------------------------+
# |      Function f_check_command_rename   |
# +----------------------------------------+
#
#  Inputs: $1=GUI.
#    Uses: ERROR.
# Outputs: None.
#
# Summary: Check if the "rename" command is available.
#
# Dependencies: f_message, f_yn_question, f_abort, apt, command.
#
f_check_command_rename () {
     #
      # Is command "rename" installed and available?
      # Use "command -v" to determine if "rename" is installed and available?
      command -v rename >/dev/null
      # "&>/dev/null" does not work in Debian distro.
      # 1=standard messages, 2=error messages, &=both.
      ERROR=$?
      #
      # Is the "rename" command installed and available?
      if [ $ERROR -ne 0 ] ; then
         # No, the "rename" command is not installed, so install command "rename".
         f_yn_question $1 "Y" "The \"Rename\" command is not installed." "Install \"rename\" command?"
         case $ANS in
              1)
                 f_message $1 "OK" "Rename Command Unavailable" "The \"rename\" command was not installed." 0 "Continue"
              ;;
              0)
                 # "Yes" is the default answer.
                 f_message $1 "NOK" "Install App" "Installing the \"rename\" command.  Super-user password required." 3 "Continue"
                 sudo apt-get install rename
              ;;
         esac
      fi
      # Is command "rename" installed and available?
      # Use "command -v" to determine if "rename" is installed and available?
      command -v rename >/dev/null
      # "&>/dev/null" does not work in Debian distro.
      # 1=standard messages, 2=error messages, &=both.
      ERROR=$?
      #
      # Is the "rename" command installed and available?
      if [ $ERROR -ne 0 ] ; then
         # No, the "rename" command is not installed, so install command "rename".
         f_message $1 "NOK" "Rename Command Unavailable" "The \"rename\" command was not installed.\nExiting script." 3 "Continue"
         f_abort $1
      fi
      unset ERROR
      #
} # End of function f_check_command_rename
#
# +----------------------------------------+
# |          Function f_view_logs          |
# +----------------------------------------+
#
#  Inputs: $1=GUI
#    Uses: LOG_FILE
# Outputs: None.
#
# Summary: Select log files using Dialog --fselect.
#
# Dependencies: f_select_file, f_message.
#
f_view_logs () {
#
      case $1 in
              whiptail | text)
                 # Select one log file using a menu.
                 f_select_log_file_fselect $1 "Select_log_file" /home/robert/ 1
              ;;
              dialog)
                 # Select one or more log files using a checklist.
                 f_select_log_file_checklist $1
              ;;
      esac
#
} # End of function f_view_logs
#
# +----------------------------------------+
# |    Function f_select_log_file_fselect  |
# +----------------------------------------+
#
#  Inputs: $1 - GUI
#          $2 - String prompt.
#          $3 - Default directory.
#          $4 - 1/0 single/multiple files selected.
#    Uses: LOG_FILE
# Outputs: None.
#
# Summary: Select log files using Dialog --fselect.
#
# Dependencies: f_select_file, f_message.
#
f_select_log_file_fselect () {
      #
      # Blank the screen.
      clear
      #
      # Choose log file(s) to view.
      # f_select_file option $4 set to 1=single file or 0=multiple files.
      f_select_file $1 $2 $3 $4
      #
      # For-loop will allow viewing of multiple log files, if allowed.
      for LOG_FILE in $ANS
          do
             # Save ANS to a temporary file.
             cp $LOG_FILE $TEMP_FILE
             #
             # View the log file.
             f_message $1 "OK" "$LOG_FILE" $TEMP_FILE
          done
      #
      unset $LOG_FILE
      #
} # End of function f_select_log_file_fselect
#
#
# +----------------------------------------+
# |  Function f_select_log_file_radiolist  |
# +----------------------------------------+
#
#  Inputs: $1 - GUI - "dialog" or "whiptail" The CLI GUI application in use.
#          $2 - Search string to filter log file names to choose from.
#    Uses: None.
# Outputs: ANS.
#
# Summary: Select log files using Dialog --radiolist.
#
# Dependencies: f_message.
#
f_select_log_file_radiolist () {
      #
      # Format the Menu data of log files to choose from.
      #
      echo "#!/bin/bash" > $TEMP_FILE"_log_file_menu_out.txt"
      echo "#" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "VERSION=\"$VERSION\"" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#***********************************CAUTION***********************************" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "# Any edits made to this code will be lost since this code is" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "# automatically generated and updated by running the function," >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "# \"f_select_log_file_radiolist\" within the script \"file_rename.sh\"" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#***********************************CAUTION***********************************" >>$TEMP_FILE"_log_file_menu_out.txt"
      echo "# +------------------------------------+" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "# |    Function f_radiolist_log_files  |" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "# +------------------------------------+" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#  Inputs: None." >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#    Uses: None." >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "# Outputs: ANS." >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "f_radiolist_log_files () {" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "ANS=\$(dialog --stdout --radiolist \"Choose log files:\" 20 75 10 \\" >> $TEMP_FILE"_log_file_menu_out.txt"
      #
      # Get list of all mounted devices.
      #
      # Use command "ls --size --human-readable -s -t -1 file_recursive*.log"
      # Insert single quotes around description and append with "off \"
      ls --size --human-readable -s -t -1 file_rename*.log | awk '{ print $2" Log file size: "$1" off \\" }' | sed -e "s/Log file/'Log file/g" -e "s/ off \\\/' off \\\/g" >> $TEMP_FILE"_log_file_menu_out.txt"
      #
      # Finish dialog --radiolist command.
      echo ")" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "} # End of function f_radiolist_log_files." >> $TEMP_FILE"_log_file_menu_out.txt"
      #
      # Are there any log files?
      ls file_rename*.log >/dev/null
      ERROR=$?
      #
      # Are there any log files?
      if [ $ERROR -ne 0 ] ; then
         # No, log files.
         f_message $1 "NOK" "Log files missing" "No file_rename*.log files to display."
      else
         # Yes, there are log files.
         # Invoke the file $TEMP_FILE"_log_file_menu_out.txt" which contains the function, f_radiolist_log_files.
         source $TEMP_FILE"_log_file_menu_out.txt"
         f_radiolist_log_files
         ERROR=$?
         #
         # For-loop will allow viewing of multiple log files, if allowed.
         for LOG_FILE in $ANS
             do
                # Save ANS to a temporary file.
                cp $LOG_FILE $TEMP_FILE
                #
                # View the log file.
                f_message $1 "OK" "$LOG_FILE" $TEMP_FILE
             done
         #
         unset $LOG_FILE
         #
      fi
      #
      # Delete temporary file.
      if [ -e $TEMP_FILE"_log_file_menu.txt" ] ; then
         rm $TEMP_FILE"_log_file_menu.txt"
      fi
      #
      if [ -e $TEMP_FILE"_log_file_menu_out.txt" ] ; then
         rm $TEMP_FILE"_log_file_menu_out.txt"
      fi
      #
}  # End of function f_select_log_file_radiolist.
#
# +----------------------------------------------+
# |     Function f_select_log_file_checklist     |
# +----------------------------------------------+
#
#  Inputs: $1 - GUI - "dialog" or "whiptail" The CLI GUI application in use.
#    Uses: None.
# Outputs: ANS.
#
# Summary: Select log files using Dialog --checklist.
#
# Dependencies: f_message.
#
f_select_log_file_checklist () {
      #
      # Format the Menu data of log files to choose from.
      #
      echo "#!/bin/bash" > $TEMP_FILE"_log_file_menu_out.txt"
      echo "#" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "VERSION=\"$VERSION\"" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#***********************************CAUTION***********************************" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "# Any edits made to this code will be lost since this code is" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "# automatically generated and updated by running the function," >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "# \"f_select_log_file_checklist\" within the script \"file_rename.sh\"" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#***********************************CAUTION***********************************" >>$TEMP_FILE"_log_file_menu_out.txt"
      echo "# +------------------------------------+" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "# |    Function f_checklist_log_files  |" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "# +------------------------------------+" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#  Inputs: None." >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#    Uses: None." >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "# Outputs: ANS." >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "f_checklist_log_files () {" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "#" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "ANS=\$(dialog --stdout --checklist \"Choose log files:\" 20 75 10 \\" >> $TEMP_FILE"_log_file_menu_out.txt"
      #
      # Get list of all mounted devices.
      #
      # Use command "ls --size --human-readable -s -t -1 file_recursive*.log"
      # Insert single quotes around description and append with "off \"
      ls --size --human-readable -s -t -1 file_rename*.log | awk '{ print $2" Log file size: "$1" off \\" }' | sed -e "s/Log file/'Log file/g" -e "s/ off \\\/' off \\\/g" >> $TEMP_FILE"_log_file_menu_out.txt"
      #
      # Finish dialog --radiolist command.
      echo ")" >> $TEMP_FILE"_log_file_menu_out.txt"
      echo "} # End of function f_checklist_log_files." >> $TEMP_FILE"_log_file_menu_out.txt"
      #
      # Are there any log files?
      ls file_rename*.log >/dev/null
      ERROR=$?
      #
      # Are there any log files?
      if [ $ERROR -ne 0 ] ; then
         # No, log files.
         f_message $1 "NOK" "Log files missing" "No file_rename*.log files to display."
      else
         # Yes, there are log files.
         # Invoke the file $TEMP_FILE"_log_file_menu_out.txt" which contains the function, f_checklist_log_files.
         source $TEMP_FILE"_log_file_menu_out.txt"
         f_checklist_log_files
         ERROR=$?
         #
         # For-loop will allow viewing of multiple log files, if allowed.
         for LOG_FILE in $ANS
             do
                # Save ANS to a temporary file.
                cp $LOG_FILE $TEMP_FILE
                #
                # View the log file.
                f_message $1 "OK" "$LOG_FILE" $TEMP_FILE
             done
         #
         unset $LOG_FILE
         #
      fi
      #
      # Delete temporary file.
      if [ -e $TEMP_FILE"_log_file_menu.txt" ] ; then
         rm $TEMP_FILE"_log_file_menu.txt"
      fi
      #
      if [ -e $TEMP_FILE"_log_file_menu_out.txt" ] ; then
         rm $TEMP_FILE"_log_file_menu_out.txt"
      fi
      #
}  # End of function f_select_log_file_checklist.
#
#
# **************************************
# **************************************
# ***     Start of Main Program      ***
# **************************************
# **************************************
#     Rev: 2021-04-19
#
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
# Blank the screen.
clear
#
#echo "Running script $THIS_FILE"
#echo "***   Rev. $VERSION   ***"
#echo
# pause for 1 second automatically.
#sleep 1
#
# Blank the screen.
#clear
#
#-------------------------------------------------------
# Detect and download any missing scripts and libraries.
#-------------------------------------------------------
#
#----------------------------------------------------------------
# Variables FILE_LIST and FILE_DL_LIST are defined in the section
# "Default Variable Values" at the beginning of this script.
#----------------------------------------------------------------
#
# Are any files/libraries missing?
fdl_download_missing_scripts $FILE_LIST $FILE_DL_LIST
#
# Are there any problems with the download/copy of missing scripts?
if [ -r  $FILE_DL_LIST ] || [ $ERROR -ne 0 ] ; then
   # Yes, there were missing files or download/copy problems so exit program.
   #
   # Delete temporary files.
   if [ -e $TEMP_FILE ] ; then
      rm $TEMP_FILE
   fi
   #
   if [ -e $FILE_LIST ] ; then
      rm $FILE_LIST
   fi
   #
   if [ -e $FILE_DL_LIST ] ; then
      rm $FILE_DL_LIST
   fi
   #
   exit 0  # This cleanly closes the process generated by #!bin/bash.
           # Otherwise every time this script is run, another instance of
           # process /bin/bash is created using up resources.
fi
#
#***************************************************************
# Process Any Optional Arguments and Set Variables THIS_DIR, GUI
#***************************************************************
#
# Set THIS_DIR, SCRIPT_PATH to directory path of script.
f_script_path
#
# Set Temporary file using $THIS_DIR from f_script_path.
TEMP_FILE=$THIS_DIR/$THIS_FILE"_temp.txt"
#
# If command already specifies GUI, then do not detect GUI.
# i.e. "bash menu.sh dialog" or "bash menu.sh text".
if [ -z $GUI ] ; then
   # Test for GUI (Whiptail or Dialog) or pure text environment.
   f_detect_ui
fi
#
# Final Check of Environment
#GUI="whiptail"  # Diagnostic line.
#GUI="dialog"    # Diagnostic line.
#GUI="text"      # Diagnostic line.
#
# Define Target Directory (This must be before f_arguments).
TARGET_DIR=""
#
# Test for Optional Arguments.
# Also sets variable GUI.
f_arguments $1 $2
#
# Delete temporary files.
if [ -e $FILE_LIST ] ; then
   rm $FILE_LIST
fi
#
if [ -e $FILE_DL_LIST ] ; then
   rm $FILE_DL_LIST
fi
#
# Test for X-Windows environment. Cannot run in CLI for LibreOffice.
# if [ x$DISPLAY = x ] ; then
#    f_message text "OK" "\Z1\ZbCannot run LibreOffice without an X-Windows environment.\ni.e. LibreOffice must run in a terminal emulator in an X-Window.\Zn"
# fi
#
# Test for BASH environment.
f_test_environment $1
#
# If an error occurs, the f_abort() function will be called.
# trap 'f_abort' 0
# set -e
#
#***************
# Run Main Code.
#***************
#
if [ -n "$TARGET_DIR" ] && [ -d "$TARGET_DIR" ] ; then
   # TARGET_DIR is defined by f_arguments and is passed as a first argument to file_rename.sh.
   # If no argument is passed, then the default TARGET_DIR is the current directory of this script.
   f_main_action $GUI "$TARGET_DIR"
else
   #
   # Blank the screen.
   clear
   #
   echo "Running script $THIS_FILE"
   echo "***   Rev. $VERSION   ***"
   echo
   # pause for 1 second automatically.
   sleep 1
   #
   # Blank the screen.
   clear
   #
   #********************************
   # Show Brief Description message.
   #********************************
   #
   # Only display Brief Description if no Target Directory was pre-specified.
   # This will prevent script file_recursive_rename.sh from displaying it
   # every time a different sub-directory is processed.
   #
   f_about $GUI "NOK" 1
   #
   # Display Main Menu.
   f_menu_main $GUI
fi
#
# Delete temporary files.
#
if [ -e $TEMP_FILE ] ; then
   rm $TEMP_FILE
fi
#
if [ -e $FILE_LIST ] ; then
   rm $FILE_LIST
fi
#
if [ -e $FILE_DL_LIST ] ; then
   rm $FILE_DL_LIST
fi
#
# Nicer ending especially if you chose custom colors for this script.
# Blank the screen.
clear
#
exit 0  # This cleanly closes the process generated by #!bin/bash.
        # Otherwise every time this script is run, another instance of
        # process /bin/bash is created using up resources.
        #
# All dun dun noodles.
