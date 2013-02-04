#!/bin/bash
HOST='ftp.mattalcock.com'
USER='mattalc1'
TARGETFOLDER='/public_html/blog'
SOURCEFOLDER='/Users/mattalcock/Dev/blog/_build'

#lftp was installed using  'brew install lftp'

lftp -f "
open $HOST
user $USER $BLOGPASS
lcd $SOURCEFOLDER
mirror --reverse --delete --verbose $SOURCEFOLDER $TARGETFOLDER
bye
"