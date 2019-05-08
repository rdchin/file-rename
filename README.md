These scripts automate the enforcement of certain file naming conventions.

Script file_recursive_rename.sh recursively renames files in the sub-directories
under the specified directory. It does not rename directories.

   Usage: bash file_recursive_rename.sh [ TARGET DIRECTORY ]
          bash file_recursive_rename.sh /home/user/Documents
          (renames files in /home/user/Documents, /home/user/Documents/<sub-directories>)


Script file_rename.sh is for renaming files under the specified directory.

   Usage: bash file_rename.sh [ TARGET DIRECTORY ]
          bash file_rename.sh /home/user/Documents

 Summary:

 If you save articles from web pages as PDF files and use the title 
 of the article as the PDF file name, you will probably end up with
 various punctuation marks in your file name which are incompatible
 or undesirable for any given Operating System (i.e. Unix, Linux,
 Microsoft, Apple, Android).

 Such file names derived from article titles often will contain
 punctuation marks such as "?", "!", "/", "&", "%".

 This script was written to enforce some of the file naming conventions
 to ensure inter-Operating System compatibility.
