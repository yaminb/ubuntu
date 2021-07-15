#!/bin/bash
set -x #echo on

echo "This is not a proper script but a collection of settings for firefox that I like to set"

#at some point move this to js and into easy to import firefox


#reduce session restore to save ssd
echo "browser.sessionstore.privacy_level=2"
echo "browser.sessionstore.resume_from_crash=false"


echo "browser.download.useDownloadDir=false"

