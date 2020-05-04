(require 'package)
;;;(add-to-list 'package-archives
;;;'             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
                '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives
                '("melpa" . "http://melpa.org/packages/")
                t)

(add-to-list 'package-archives 
                '("org" . "http://orgmode.org/elpa/")
                t)
(when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)



(unless (package-installed-p 'use-package)
(package-refresh-contents)
(package-install 'use-package))
;;  (setq use-package-verbose t)
;;  (setq use-package-always-ensure t)
;; (eval-when-compile
;; (require 'use-package))
;; (use-package auto-compile
;; :config (auto-compile-on-load-mode))
;; (require 'diminish)
;;  ;;
(require 'bind-key)

(dolist (pkg '(org-plus-contrib htmlize s))
  (unless (package-installed-p pkg)
    (package-install pkg)))

(use-package s
    :ensure t)

(require 'org)
(require 'ox-publish)
(require 'ox-html)

;; Hack into source block Export function to Delegate syntax highlighting to jekyll

;; {% comment %}

;; Link Funcitonality FastPages



;;{% comment %}

(defun jekyll-highlight (lang code)
  (format "{%% highlight %s %%}\n%s{%% endhighlight %%}" lang code))
  
(defun jekyll-include (inc-tmpl url)
   (s-lex-format "{% include ${inc-tmpl} content='<a href=\"${url}\">${url}</a>' %}"))


(defun jekyll-include-box (inc-tmpl inputtype text)
  (s-lex-format "{% include ${inc-tmpl} ${inputtype}=\"${text}\" %}"))



(defun jekyll-include-remote-img (url caption)
  (if caption
	(s-lex-format "{% include image.html url='${url}' caption='${caption}' file='${url}' alt='${caption}' %}")
    (s-lex-format "{% include image.html url='${url}' file='${url}' alt='Image' %}")))

;; {% endcomment %}

(defun jekyll-include-local-img (url caption)
  (let ((n_url (s-lex-format "{{site.baseurl}}${url}")))
    (if caption
	  (s-lex-format "<figure>
    <img src=\"${n_url}\"
	   alt=\"${caption}\">
    <figcaption>${caption}</figcaption>
</figure>")
	(s-lex-format "<figure>
    <img src=\"${n_url}\" >
</figure>"))))


(defun embed-img (url caption)
  (cond ((s-starts-with? "/images" url) (jekyll-include-local-img url caption))
	  ((s-starts-with? "/assets" url) (jekyll-include-local-img url caption))
	  (t (jekyll-include-remote-img url caption))))

;;(jekyll-include-img "/images/Emacs.png" "Emacs")

(defun embed-iframe (url)
  (s-lex-format " <div style=\"text-align: center;\">
	<iframe width=\"560\" height=\"315\" src=\"${url}\" frameborder=\"0\" allow=\"autoplay; encrypted-media\" allowfullscreen></iframe>
   </div>"))


(defun get-yt-code (url)
  (car (s-split "&list=" (s-chop-prefixes '("https://www.youtube.com/watch?v=" "https://www.youtube.com/playlist?list=" "https://youtu.be/") url))))

;;(get-yt-code "https://www.youtube.com/watch?v=SmH3BPpl0TI")
;;(get-yt-code "https://www.youtube.com/playlist?list=PLxc79l2wpbJYTI5rv2os7OoKQMqxReZpr")
;;(get-yt-code "https://www.youtube.com/watch?v=SzA2YODtgK4&list=PLxc79l2wpbJYTI5rv2os7OoKQMqxReZpr")
;;(get-yt-code "https://youtu.be/VawlmG9tsXI")


(defun embed-yt(url)
  (if (s-starts-with? "https://www.youtube.com/playlist?list=" url)
	(let ((code (get-yt-code url))
	      (embed-base "https://www.youtube.com/embed/videoseries?list="))
	  (embed-iframe (concat embed-base code)))
    (jekyll-include "youtube.html" (concat "https://youtu.be/" (get-yt-code url)))))

;;(embed-yt "https://www.youtube.com/watch?v=SmH3BPpl0TI")
;;(embed-yt "https://www.youtube.com/playlist?list=PLxc79l2wpbJYTI5rv2os7OoKQMqxReZpr")
;;(embed-yt "https://youtu.be/VawlmG9tsXI")

(org-link-set-parameters
 "yt"
 :export (lambda (path desc backend)
	     (cond
	      ((eq 'html backend)
	       (embed-yt path ))))
 :help-echo "This links helps in exporting link to jekyll youtube liquid template")

(org-link-set-parameters
 "twitter"
 :export (lambda (path desc backend)
	     (cond
	      ((eq 'html backend)
	       (jekyll-include "twitter.html" path ))))
 :help-echo "This links helps in exporting link to jekyll liquid twitter template")

(org-link-set-parameters
 "img"
 :export (lambda (path desc backend)
	     (cond
	      ((eq 'html backend)
	       (embed-img  path desc))))
 :help-echo "This links helps in exporting link to jekyll liquid image template")

(org-link-set-parameters
 "alert"
 :face '(:foreground "red" :underline t)
 :export (lambda (path desc backend)
	     (cond
	      ((eq 'html backend)
	       (jekyll-include-box "alert.html" "text" (or desc path)))))
 :help-echo "This links helps in exporting link to jekyll alert template")


(org-link-set-parameters
 "info"
 :face '(:foreground "blue" :underline t)
 :export (lambda (path desc backend)
	     (cond
	      ((eq 'html backend)
	       (jekyll-include-box "info.html" "text" (or desc path)))))
 :help-echo "This links helps in exporting link to jekyll info template")


(org-link-set-parameters
 "warning"
 :face '(:foreground "pink")
 :export (lambda (path desc backend)
	     (cond
	      ((eq 'html backend)
	       (jekyll-include-box "warning.html" "content" (or desc path)))))
 :help-echo "This links helps in exporting link to jekyll warning template")


(org-link-set-parameters
 "important"
 :face '(:foreground "yellow")
 :export (lambda (path desc backend)
	     (cond
	      ((eq 'html backend)
	       (jekyll-include-box "important.html" "content" (or desc path)))))
 :help-echo "This links helps in exporting link to jekyll important template")

(org-link-set-parameters
 "tip"
 :face '(:foreground "green")
 :export (lambda (path desc backend)
	     (cond
	      ((eq 'html backend)
	       (jekyll-include-box "tip.html" "content" (or desc path)))))
 :help-echo "This links helps in exporting link to jekyll tip template")


(org-link-set-parameters
 "note"
 :face '(:foreground "light blue")
 :export (lambda (path desc backend)
	     (cond
	      ((eq 'html backend)
	       (jekyll-include-box "note.html" "content" (or desc path)))))
 :help-echo "This links helps in exporting link to jekyll note template")

  (org-link-set-parameters
  "iframe"
  :export (lambda (path desc backend)
      (cond
          ((eq 'html backend)
          (embed-iframe path ))))
  :help-echo "This links help in embedding iframe and revealjs presentation")


(setq org-html-htmlize-output-type nil)

;; Define A new backend for fastpages html export

(defun org-fp-code-folding (block)
  (s-lex-format "<div class=\"cell border-box-sizing code_cell rendered\">
    <details class=\"description\">
      <summary class=\"btn btn-sm\" data-open=\"Hide Code\" data-close=\"Show Code\"></summary>
        <p>
           <div class=\"input\">
                ${block}
          </div>
        </p>
    </details>
</div>"))
 
(defun org-fp-html-src-block (src-block contents info)
  "Transcode a SRC-BLOCK element from Org to HTML.
CONTENTS holds the contents of the item.  INFO is a plist holding
contextual information."
  (if (org-export-read-attribute :attr_html src-block :textarea)
	(org-html--textarea-block src-block)
    (let ((lang (org-element-property :language src-block))
	    (caption (org-export-get-caption src-block))
	    (code (org-html-format-code src-block info))
	    (label (let ((lbl (and (org-element-property :name src-block)
				   (org-export-get-reference src-block info))))
		     (if lbl (format " id=\"%s\"" lbl) ""))))
        (org-fp-code-folding
	(if (not lang) (format "<pre class=\"example\"%s>\n%s</pre>" label code)
	  (format
	   "<div class=\"org-src-container\">\n%s%s\n</div>"
	   (if (not caption) ""
	     (format "<label class=\"org-src-name\">%s</label>"
		     (org-export-data caption info)))
	   (jekyll-highlight lang code)))))))

;;	 (format "\n<pre class=\"src src-%s\"%s>%s</pre>" lang label code))))))

(defun org-fp-inline-src-block (inline-src-block _contents info)
  "Transcode an INLINE-SRC-BLOCK element from Org to HTML.
  CONTENTS holds the contents of the item.  INFO is a plist holding
  contextual information."
  (let* ((lang (org-element-property :language inline-src-block))
	   (code (org-html-fontify-code
		  (org-element-property :value inline-src-block)
		  lang))
	   (label
	    (let ((lbl (and (org-element-property :name inline-src-block)
			    (org-export-get-reference inline-src-block info))))
	      (if (not lbl) "" (format " id=\"%s\"" lbl)))))
    (jekyll-highlight lang code)))



(org-export-define-derived-backend 'fastpages 'html
  :menu-entry
  '(?f "FastPages Export Backend"
	 ((?A "As HTML Buffer (Fastpages)" org-fp-export-as-html)
	  (?a "As HTML file (Fastpages)" org-fp-export-to-html)))
  :translate-alist '((inline-src-block . org-fp-inline-src-block)
		       (src-block . org-fp-html-src-block)))



;;;###autoload
(defun org-fp-export-as-html
  (&optional async subtreep visible-only body-only ext-plist)

  (interactive)
  (org-export-to-buffer 'fastpages "*Org FP HTML Export*"
    async subtreep visible-only body-only ext-plist
    (lambda () (set-auto-mode t))))

;;;###autoload
(defun org-fp-convert-region-to-html ()

  (interactive)
  (org-export-replace-region-by 'fastpages))

;;;###autoload
(defun org-fp-export-to-html
  (&optional async subtreep visible-only body-only ext-plist)


  (interactive)
  (let* ((extension (concat
		       (when (> (length org-html-extension) 0) ".")
		       (or (plist-get ext-plist :html-extension)
			   org-html-extension
			   "html")))
	   (file (org-export-output-file-name extension subtreep))
	   (org-export-coding-system org-html-coding-system))
    (org-export-to-file 'fastpages file
	async subtreep visible-only body-only ext-plist)))

;;;###autoload
(defun org-fp-publish-to-html (plist filename pub-dir)

  (org-publish-org-to 'fastpages filename
			(concat (when (> (length org-html-extension) 0) ".")
				(or (plist-get plist :html-extension)
				    org-html-extension
				    "html"))
			plist pub-dir))

(provide 'fpemacs)
