#!/bin/sh

echo "Inside custom converter code"
# emacs --batch --no-init-file --load ./_custom_action_files/publish.el --funcall toggle-debug-on-error --funcall fastpages-publish-all
rm -rf /root/.org-timestamps
emacs --batch --no-init-file --load ./_custom_action_files/fpemacs.el --load ./_custom_action_files/publish.el --funcall toggle-debug-on-error --funcall fastpages-publish-all
