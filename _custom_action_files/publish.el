(require 'package)
(package-initialize)
(unless package-archive-contents
  (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (package-refresh-contents))
(dolist (pkg '(org-plus-contrib htmlize))
  (unless (package-installed-p pkg)
    (package-install pkg)))

(require 'org)
(require 'ox-rss)
(require 'ox-publish)
(require 'ox-html)
(require 'fpemacs)

(setq org-html-htmlize-output-type nil)

(setq org-publish-project-alist
	'(

    ("org-post-fastpages"
	    ;; Path to your org files.
	    :base-directory "./_org/_posts"
	    :base-extension "org"

	    ;; Path to your Jekyll project.
	    :publishing-directory "./_posts/"
	    :recursive t
	    :publishing-function org-fp-publish-to-html
	    :html-extension "md"
	    :body-only t ;; Only export section between <body> </body>
      )


      ("org-static-fastpages"
	    :base-directory "./_org/assets"
	    :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|php"
	    :publishing-directory "./assets/"
	    :recursive t
	    :publishing-function org-publish-attachment
	    )

      ("org-images-fastpages"
	    :base-directory "./_org/images"
	    :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|php"
	    :publishing-directory "./images/"
	    :recursive t
	    :publishing-function org-publish-attachment
	    )
      ("fastpages" :components ("org-post-fastpages" "org-static-fastpages" "org-images-fastpages"))

  ))

(defun fastpages-publish-all ()
  "Publish the blog to HTML."
  (interactive)
  (org-publish-all))


(provide 'publish)



