(require 'iso-transl) ; deadkeys problems with ubuntu
(global-auto-revert-mode t) ;; raffraîchit les buffers en cas de svn up

;current buffer path in window title invocation-name
(setq frame-title-format
      '("" (:eval (persp-name persp-curr)) ": "
	(:eval (if (buffer-file-name)
       (abbreviate-file-name (buffer-file-name))
     "%b"))))


(defvar emacs-linux (string-match "linux" system-configuration))

(cond
 ((string-match "Emacs 23" (emacs-version))
  (require 'color-theme)
  (load "~/.emacs.d/zenburn")
  (color-theme-zenburn)
  )

 ((string-match "Emacs 24" (emacs-version))
  (require 'package)
  (package-initialize)
  (setq package-archives
        '(
          ("gnu" . "http://elpa.gnu.org/packages/")
          ("marmalade" . "http://marmalade-repo.org/packages/")
          ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
          ;("melpa" . "http://melpa.milkbox.net/packages/")
          )
        )
  )
)
(cond
 ((string-match "darwin" system-configuration)
  (setenv "PATH" "/opt/local/bin:/opt/local/sbin:/opt/local/libexec/gnubin/:/Volumes/home/fredz/bin:.:/Volumes/home/fredz/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin")
  (desktop-save-mode 1)
  (setq mac-option-modifier nil
	mac-command-modifier 'meta
	x-select-enable-clipboard t)
  (set-face-attribute 'default nil :font "-apple-Monaco-medium-normal-normal-*-14-*-*-*-m-0-iso10646-1")
  (setq initial-frame-alist default-frame-alist)
  (toggle-frame-fullscreen)
  )
 ((string= system-name "yoga")
  (set-face-attribute 'default nil :font "Droid Sans Mono:pixelsize=33:foundry=unknown:weight=normal:slant=normal:width=normal:spacing=100:scalable=true")
  (desktop-save-mode 1)
  (menu-bar-mode 0)
  ; (load-theme 'obsidian t)
  ; (load-theme 'tango-plus t)
  )

 ((string-match "pimentech.net" system-name)
  (set-face-attribute 'default nil :font "-unknown-Droid Sans Mono-normal-normal-normal-*-16-*-*-*-m-0-iso10646-1")
  (load-theme 'ample-zen t)

  (menu-bar-mode 0)
  (persp-mode)
  (quick-perspective-keys)
  (persp-switch "pdf")
  (persp-switch "notesgroup")
  (persp-switch "samusocial")
  (persp-switch "main")  )

 )





(outline-minor-mode 1)
(eval-after-load 'outline
  '(progn
    (require 'outline-magic)
    (define-key outline-minor-mode-map (kbd "<C-tab>") 'outline-cycle)))

(add-hook 'org-mode-hook
      (lambda ()
	(local-set-key "\C-c\C-p" 'org-publish-current-project)
	;;(require 'org-publish)
	(setq org-publish-project-alist
      '(
	("samusocial-src"
     :base-directory "~/src/samusocial/branches/2/src/dj/samusocial"
     :publishing-directory "/ssh:fredz@safran.pimentech.net:~/public_html/samusocial"
     :base-extension "org"
     :table-of-contents nil
     :recursive t
     :publishing-function org-html-publish-to-html
     :author-info "PimenTech"
     :creator-info nil
     :html-language "fr"
     :makeindex t
     :auto-sitemap nil
     :sitemap-ignore-case t
     :htmlized-source nil
     :section-numbers nil
     :html-head "<link rel=\"stylesheet\" href=\"http://pimente.ch/scripts/css/org.css\" type=\"text/css\" />"
     )
	("samusocial-static"
     :base-directory "~/src/samusocial/branches/2/src/dj/samusocial"
     :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf"
     :publishing-directory "/ssh:fredz@safran.pimentech.net:~/public_html/samusocial"
     :recursive t
     :publishing-function org-publish-attachment
     )
	("samusocial" :components ("samusocial-src"
       "samusocial-static"))
	)
      )


	(setq org-plantuml-jar-path "/usr/share/plantuml/plantuml.jar")
	(add-hook 'org-babel-after-execute-hook
      'bh/display-inline-images 'append)
	;; Make babel results blocks lowercase
	(setq org-babel-results-keyword "results")
	(defun bh/display-inline-images ()
      (condition-case nil
      (org-display-inline-images)
		(error nil)))
	(org-babel-do-load-languages
     (quote org-babel-load-languages)
     (quote ((emacs-lisp . t)
     (dot . t)
     (ditaa . t)
     (R . t)
     (python . t)
     (ruby . t)
     (gnuplot . t)
     (clojure . t)
     (sh . t)
     (ledger . t)
     (org . t)
     (plantuml . t)
     (latex . t))))
	;; Do not prompt to confirm evaluation
	:; This may be dangerous - make sure you understand the consequences
	:; of setting this -- see the docstring for details
	(setq org-confirm-babel-evaluate nil)
	;; Use fundamental mode when editing plantuml blocks with C-c '
	(add-to-list 'org-src-lang-modes (quote ("plantuml" . fundamental)))
	))


;(require 'whitespace)
(autoload 'whitespace-mode           "whitespace" "Toggle whitespace visualization."        t)
(autoload 'whitespace-toggle-options "whitespace" "Toggle local `whitespace-mode' options." t)
;; nuke whitespaces when writing to a file
(add-hook 'before-save-hook 'whitespace-cleanup)


(when (locate-library "diff-hl")
  (require 'diff-hl)
  (defadvice svn-status-update-modeline (after svn-update-diff-hl activate)
    (diff-hl-update))
)


(setq locale-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; global shortcuts
(global-set-key [f12] 'menu-bar-mode)
(global-set-key "\eg" 'goto-line)
(global-set-key "\ef" 'grep-find)
(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)
(global-set-key [C-home] 'beginning-of-buffer)
(global-set-key [C-end] 'end-of-buffer)
(global-set-key "\C-b" 'switch-to-buffer)
(global-set-key "\C-o" 'other-window)
(global-set-key "\M-k" 'kill-this-buffer)
(global-set-key "\C-\M-g" 'magit-status)

(defun my-put-file-name-on-clipboard ()
  "Put the current file name on the clipboard"
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
      default-directory
	(buffer-file-name))))
    (when filename
      (with-temp-buffer
	(insert filename)
	(clipboard-kill-region (point-min) (point-max)))
      (message filename))))

(defun my-multi-occur-in-matching-buffers (regexp &optional allbufs)
  "Show all lines matching REGEXP in all buffers."
  (interactive (occur-read-primary-args))
  (multi-occur-in-matching-buffers ".*" regexp))
(global-set-key (kbd "M-s /") 'my-multi-occur-in-matching-buffers)


;;; special gettext
(require 'iso-cvt)
(setq liste iso-iso2sgml-trans-tab)
(defvar trans-hash (make-hash-table :test 'equal))
(let (args arg key val)
  (setq args (pop args))
  (while liste
    (setq arg (pop liste))
    (setq key (pop arg))
    (setq val (pop arg))
    (puthash key val trans-hash)
    )
  )
(puthash "\"" "&quot;" trans-hash)

(defun hh (c)
    (let (o)
      (setq o (gethash (string c) trans-hash))
      (if o o (string c))
      )
)

(defun chomp (str)
      (while (string-match "\\`\n+\\|^\\s-+\\|\\s-+$\\|\n+\\'\\|  \\|
" str)
	(setq str (replace-match "" t t str)))
      str)


(defun iso2sgmlentitystring (s)
  (mapconcat 'identity (mapcar 'hh (string-to-list (chomp s))) "")
)

(defun trans_text ()
  (interactive)
  (let ((case-fold-search nil))
    (query-replace-regexp ">\\([^<^\{^\}]*[a-z][^<^\{^\}]*\\)<"
      (quote (replace-eval-replacement concat ">{% trans \"" (replace-quote (iso2sgmlentitystring (match-string 1))) "\" %}<")) nil
      (if (and transient-mark-mode mark-active) (region-beginning)) (if (and transient-mark-mode mark-active) (region-end)))
    )
)
;;; /special gettext



(require 'printing)		; load printing package

(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
       'flymake-create-temp-inplace))
       (local-file (file-relative-name
			temp-file
			(file-name-directory buffer-file-name))))
      (list "pyflakes" (list local-file))))
  )

(add-hook 'find-file-hook 'flymake-find-file-hook)
;; Additional functionality that makes flymake error messages appear
;; in the minibuffer when point is on a line containing a flymake
;; error. This saves having to mouse over the error, which is a
;; keyboard user's annoyance

;;flymake-ler(file line type text &optional full-file)
(defun show-fly-err-at-point ()
  "If the cursor is sitting on a flymake error, display the
message in the minibuffer"
  (interactive)
  (let ((line-no (line-number-at-pos)))
    (dolist (elem flymake-err-info)
      (if (eq (car elem) line-no)
      (let ((err (car (second elem))))
	(message "%s" (fly-pyflake-determine-message err)))))))

(defun fly-pyflake-determine-message (err)
  "pyflake is flakey if it has compile problems, this adjusts the
message to display, so there is one ;)"
  (cond ((not (or (eq major-mode 'Python) (eq major-mode 'python-mode) t)))
	((null (flymake-ler-file err))
     ;; normal message do your thing
     (flymake-ler-text err))
	(t ;; could not compile err
     (format "compile error, problem on line %s" (flymake-ler-line err)))))

(defadvice flymake-goto-next-error (after display-message activate compile)
  "Display the error in the mini-buffer rather than having to mouse over it"
  (show-fly-err-at-point))

(defadvice flymake-goto-prev-error (after display-message activate compile)
  "Display the error in the mini-buffer rather than having to mouse over it"
  (show-fly-err-at-point))

(defadvice flymake-mode (before post-command-stuff activate compile)
  "Add functionality to the post command hook so that if the
cursor is sitting on a flymake error the error information is
displayed in the minibuffer (rather than having to mouse over
it)"
  (set (make-local-variable 'post-command-hook)
       (cons 'show-fly-err-at-point post-command-hook)))






(defun font-existsp (font)
  "Check that a font exists: http://www.emacswiki.org/emacs/SetFonts#toc8"
  (and (window-system)
       (fboundp 'x-list-fonts)
       (x-list-fonts font)))


;; (setq kjfletch-font-list
;;       '(;; List of fonts to search for in order of priority.
;;  "Droid Sans Mono-14" "Ubuntu Mono-18" "Source Code Pro Regular"  "Consolas-10" "ProggyOpti-8"
;;  "ProggyOptiS-8" "ProggyClean-10" "Consolas-8"
;;  "DejaVu Sans Mono-20" "Courier New-8"
;;  ))
;; (let* ((in-loop t)
;;        (font (car kjfletch-font-list))
;;        (rest (cdr kjfletch-font-list)))
;;   (while (and font in-loop)
;;     (when (font-existsp font)
;;       (set-face-attribute 'default nil :font font)
;;       (setq in-loop nil))
;;     (setq font (car rest)
;;       rest (cdr rest))))

(put 'narrow-to-region 'disabled nil)


(defun increment-number-at-point ()
      (interactive)
      (skip-chars-backward "0123456789")
      (or (looking-at "[0123456789]+")
      (error "No number at point"))
      (replace-match (number-to-string (1+ (string-to-number (match-string 0))))))
(global-set-key (kbd "C-c +") 'increment-number-at-point)

(setq indent-tabs-mode nil)

(setq inhibit-startup-message t)


;;(setq frame-title-format '((buffer-file-name "%f - ") "%b"))
(setq make-backup-files nil)

(server-start)

;(require 'psvn)
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(set-face-bold-p 'font-lock-keyword-face t)
(set-face-italic-p 'font-lock-comment-face t)

(require 'ido)
(ido-mode nil)



;; CTRL-ALT Y : Duplique la ligne
(defun djcb-duplicate-line (&optional commentfirst)
  (interactive)
  (beginning-of-line)
  (let
      ((beg (point)))
    (end-of-line)
    (let ((str (buffer-substring beg (point))))
      (when commentfirst
	(comment-region beg (point)))
      (insert
       (concat (if (= 0 (forward-line 1)) "" "\n") str "\n"))
      (forward-line -1))))
(global-set-key "\C-\M-y" 'djcb-duplicate-line)



(defun django-insert-trans (from to &optional buffer)
 (interactive "*r")
 (save-excursion
   (save-restriction
     (narrow-to-region from to)
     (goto-char from)
     (iso-iso2sgml from to)
     (insert "{% trans \"")
     (goto-char (point-max))
     (insert "\" %}")
     (point-max))))
(defun django-insert-transpy (from to &optional buffer)
 (interactive "*r")
 (save-excursion
   (save-restriction
     (narrow-to-region from to)
     (goto-char from)
     (iso-iso2sgml from to)
     (insert "_(")
     (goto-char (point-max))
     (insert ")")
     (point-max))))


(defun django-form-help-text (&optional buffer)
  (interactive)
  (kill-line)
     (yank)
     (yank)
     (backward-char 3)
     (insert ".help_text")
     (beginning-of-line)
)


(defvar py-outline-regexp "^\\([ \t]*\\)\\(def\\|class\\|if\\|elif\\|else\\|while\\|for\\|try\\|except\\|with\\)"
  "This variable defines what constitutes a 'headline' to outline mode.")
(defun py-outline-level ()
  "Report outline level for Python outlining."
  (save-excursion
    (end-of-line)
    (let ((indentation (progn
     (re-search-backward py-outline-regexp)
     (match-string-no-properties 1))))
      (if (and (> (length indentation) 0)
       (string= "\t" (substring indentation 0 1)))
      (length indentation)
	(/ (length indentation) 4))))) ; py-indent-offset



(add-hook 'web-mode-hook
          '(lambda ()
             (set-face-attribute 'web-mode-html-tag-face nil
                                 :foreground "LightBlue" :weight 'bold)
             (setq web-mode-markup-indent-offset 4)
             (setq web-mode-code-indent-offset 2
                   web-mode-markup-indent-offset 2
                   web-mode-tag-auto-close-style 2
                   web-mode-void-elements
                   '("area" "base" "br" "col" "command" "embed" "hr" "img" "input" "keygen"
                     "link" "meta" "param" "source" "track" "wbr" "dtml-var" "dtml-else"
                     "dtml-call" "dtml-with" "dtml-let")
                   )

             (local-set-key "\C-c\C-g" 'django-insert-trans)
             (local-set-key (kbd "C-c <left>") 'web-mode-fold-or-unfold)
             (local-set-key (kbd "C-c <right>") 'web-mode-fold-or-unfold)
             (local-set-key (kbd "C-c <down>") 'web-mode-element-end)
             (local-set-key (kbd "C-c <up>") 'web-mode-element-beginning)
             )
          )
;(set-face-attribute 'web-mode-html-tag-face nil :inherit font-lock-keyword-face)


(add-hook 'python-mode-hook
      '(lambda ()
     (outline-minor-mode 1)
     (setq
      tab-width 4
      python-indent 4
      outline-regexp py-outline-regexp
      outline-level 'py-outline-level)
     (local-set-key "\C-c\C-t" 'django-insert-transpy)
     (local-set-key [f9] (lambda () (interactive) (insert "import ipdb;ipdb.set_trace()")))
     (local-set-key (kbd "C-c <left>") 'hide-subtree)
     (local-set-key (kbd "C-c <right>") 'show-subtree)
     ))

(add-hook 'sgml-mode-hook
      (lambda ()
	(local-set-key "\C-c\C-g" 'django-insert-trans)
	(setq indent-tabs-mode nil)
	))
(add-hook 'js2-mode-hook
      (lambda ()
	(setq indent-tabs-mode nil)
	(local-set-key (kbd "C-c <left>") 'js2-mode-toggle-element)
	(local-set-key (kbd "C-c <right>") 'js2-mode-toggle-element)
	))


(add-hook 'js2-post-parse-callbacks
      (lambda ()
	(when (> (buffer-size) 0)
      (let ((btext (replace-regexp-in-string
		": *true" " "
		(replace-regexp-in-string "[\n\t ]+" " " (buffer-substring-no-properties 1 (buffer-size)) t t))))
		(mapc (apply-partially 'add-to-list 'js2-additional-externs)
      (split-string
       (if (string-match "/\\* *global *\\(.*?\\) *\\*/" btext) (match-string-no-properties 1 btext) "")
       " *, *" t))
		))))

(add-hook 'nxml-mode-hook
      (lambda ()
	(local-set-key (kbd "C-c <up>") 'nxml-backward-element)
	(local-set-key (kbd "C-c <down>") 'nxml-forward-element)
	))



(when (locate-library "auctex")
  (load "auctex.el" nil t t)
  ;(load "preview-latex.el" nil t t)
  (require 'tex-site nil t) ; auctex
  (require 'reftex)
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
  (add-hook 'latex-mode-hook 'turn-on-reftex)   ; with Emacs latex mode

  (add-hook 'LaTeX-mode-hook
	(lambda ()
      (local-set-key (kbd "_") (lambda () (interactive) (insert "\\_")))
      ))
  (setq reftex-plug-into-AUCTeX t)
  )


(autoload 'css-mode "css-mode")
(setq cssm-indent-function #'cssm-c-style-indenter)
(setq cssm-indent-level '2)


;(add-to-list 'auto-mode-alist '("\\.[sx]?html?\\'" . django-html-mode))
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.dtml?\\'" . web-mode))
(setq web-mode-engines-alist '(("django" . "\\.html\\'") ("blade" . "\\.blade\\.")) )
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-mode))
;(add-to-list 'auto-mode-alist '("\\.dtml\\'" . html-mode))
;(add-to-list 'auto-mode-alist '("\\.inc\\'" . html-mode))
(add-to-list 'auto-mode-alist '("\\.stumpwmrc\\'" . lisp-mode))

(add-hook 'js-mode-hook 'flymake-json-maybe-load)
(setq auto-mode-alist
      (cons '("\\.\\(xml\\|xsl\\|rng\\|xhtml\\)\\'" . nxml-mode)
	auto-mode-alist))

(modify-coding-system-alist 'file "\\.dtml\\'" 'iso-latin-1)


(setq-default sgml-indent-data t)
(setq
 sgml-always-quote-attributes t
 sgml-auto-insert-required-elements t
 sgml-auto-activate-dtd t
 sgml-data-directory "/usr/share/sgml/declaration/"
 sgml-indent-data t
 sgml-indent-step             2
 sgml-minimize-attributes     nil
 sgml-omittag                 nil
 sgml-shortag                 nil
 sgml-custom-markup
 '(("Version1" "<![%Version1[\r]]>")
   ("New page"  "<?NewPage>"))
 sgml-xml-declaration "/usr/share/sgml/declaration/xml.dcl"
 sgml-display-char-list-filename "/usr/share/sgml/charsets/iso88591.map"
 sgml-live-element-indicator t
 sgml-public-map '("%S"  "/usr/share/sgml/%S" "/usr/share/sgml/%o/%c/%d"
       "/usr/local/share/sgml/%o/%c/%d" "/usr/local/lib/sgml/%o/%c/%d")
 sgml-system-path '("/usr/share/sgml" "/usr/share/sgml/cdtd" "/usr/local/share/sgml"
	"/usr/local/lib/sgml")
 sgml-tag-region-if-active t
 )

(setq-default sgml-use-text-properties t)

;; Set up the faces for markup
(setq-default sgml-markup-faces
      '((start-tag . font-lock-keyword-face)
		(end-tag . font-lock-keyword-face)
		(ignored . font-lock-string-face)
		(ms-start . font-lock-constant-face)
		(ms-end . font-lock-constant-face)
		(shortref . bold)
		(entity . font-lock-type-face)
		(comment . font-lock-comment-face)
		(pi . font-lock-builtin-face)
		(sgml . font-lock-function-name-face)
		(doctype . font-lock-variable-name-face)))
;; Turn on the markup based on whether font-lock would be on
(eval-after-load "psgml"
  '(lambda ()
     (if (boundp 'global-font-lock-mode)
     (if global-font-lock-mode
     (setq-default sgml-set-face t)
       (setq-default sgml-set-face nil))
       (setq-default sgml-set-face (eq 'x  window-system)))

     (when (default-value 'sgml-set-face)
       (require 'font-lock))
     ;; Lots of overlays in a buffer is bad news since they have to
     ;; be relocated on changes, with typically quadratic
     ;; behaviour.
     ))






(if (featurep 'tool-bar) (tool-bar-mode nil))
(toggle-tool-bar-mode-from-frame 0)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-PDF-mode t)
 '(TeX-close-quote ">>")
 '(TeX-fold-auto t)
 '(TeX-open-quote "<<")
 '(ansi-color-names-vector ["#212121" "#CC5542" "#6aaf50" "#7d7c61" "#5180b3" "#DC8CC3" "#9b55c3" "#bdbdb3"])
 '(auto-compression-mode t nil (jka-compr))
 '(case-fold-search t)
 '(column-number-mode t)
 '(csv-separators (quote ("|")))
 '(current-language-environment "utf-8")
 '(custom-enabled-themes (quote (sanityinc-solarized-light ample-zen)))
 '(custom-safe-themes (quote ("18d91d95e20450b0cdab4d7eed600e80c22cc7a4153a87989daa5a1c5aff3b83" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4")))
 '(default-input-method "rfc1345")
 '(fci-rule-color "#2e2e2e")
 '(file-coding-system-alist (quote (("\\.dz\\'" no-conversion . no-conversion) ("\\.g?z\\(~\\|\\.~[0-9]+~\\)?\\'" no-conversion . no-conversion) ("\\.tgz\\'" no-conversion . no-conversion) ("\\.tbz\\'" no-conversion . no-conversion) ("\\.bz2\\(~\\|\\.~[0-9]+~\\)?\\'" no-conversion . no-conversion) ("\\.Z\\(~\\|\\.~[0-9]+~\\)?\\'" no-conversion . no-conversion) ("\\.elc\\'" emacs-mule . emacs-mule) ("\\.utf\\(-8\\)?\\'" . utf-8) ("\\(\\`\\|/\\)loaddefs.el\\'" raw-text . raw-text-unix) ("\\.tar\\'" no-conversion . no-conversion) ("\\.po[tx]?\\'\\|\\.po\\." . po-find-file-coding-system) ("\\.\\(tex\\|ltx\\|dtx\\|drv\\)\\'" . latexenc-find-file-coding-system) ("" undecided) ("" undecided . undecided) (".-square\\.naxos-fr\\.net" utf-8 . utf-8))))
 '(flymake-allowed-file-name-masks (quote (("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'" flymake-simple-make-init) ("\\.xml\\'" flymake-xml-init) ("\\.cs\\'" flymake-simple-make-init) ("\\.h\\'" flymake-master-make-header-init flymake-master-cleanup) ("\\.idl\\'" flymake-simple-make-init) ("\\.py\\'" flymake-pyflakes-init))))
 '(fringe-mode (quote (0)) nil (fringe))
 '(global-font-lock-mode t nil (font-lock))
 '(gnus-nntp-server "news.free.fr")
 '(grep-find-command "find . -type f -not -name \"*.svn-base\" -and -not -name \"*~\" -and \\( -name \"*.html\" -or -name \"*.php*\" -or -name \"*.py\" -or -name \"*.sql\" -or -name \"*.js\" -or -name \"*.css\" -or -name \"*.sh\"  -or -name \"*.conf\" -or -name \"*.tex\" -or -name \"Makefile\" \\) -print0 | xargs -0 -e grep -n -s -F ")
 '(grep-find-ignored-directories (quote ("SCCS" "RCS" "CVS" "MCVS" ".svn" ".git" ".hg" ".bzr" "_MTN" "_darcs" "{arch}" "CACHE")))
 '(grep-find-ignored-files (quote (".#*" "*.o" "*~" "*.bin" "*.lbin" "*.so" "*.a" "*.ln" "*.blg" "*.bbl" "*.elc" "*.lof" "*.glo" "*.idx" "*.lot" "*.fmt" "*.tfm" "*.class" "*.fas" "*.lib" "*.mem" "*.x86f" "*.sparcf" "*.dfsl" "*.pfsl" "*.d64fsl" "*.p64fsl" "*.lx64fsl" "*.lx32fsl" "*.dx64fsl" "*.dx32fsl" "*.fx64fsl" "*.fx32fsl" "*.sx64fsl" "*.sx32fsl" "*.wx64fsl" "*.wx32fsl" "*.fasl" "*.ufsl" "*.fsl" "*.dxl" "*.lo" "*.la" "*.gmo" "*.mo" "*.toc" "*.aux" "*.cp" "*.fn" "*.ky" "*.pg" "*.tp" "*.vr" "*.cps" "*.fns" "*.kys" "*.pgs" "*.tps" "*.vrs" "*.pyc" "*.pyo" "*.jpg" "*.gif" "*.png" "*.JPG" "*.GIF" "*.PNG" "*.jpeg" "*.map" "*.pdf" "*.ttf" "*.swf" "*.eot" "*.*min*js" "*.*min*css")))
 '(gud-pdb-command-name "pdb.py")
 '(indent-tabs-mode nil)
 '(ispell-program-name "/usr/bin/hunspell")
 '(js2-mode-escape-quotes nil)
 '(js2-mode-squeeze-spaces nil)
 '(minibuffer-max-depth nil)
 '(nxml-auto-insert-xml-declaration-flag t)
 '(nxml-child-indent 3)
 '(nxml-default-buffer-file-coding-system (quote utf-8))
 '(org-file-apps (quote ((auto-mode . emacs) ("\\.mm\\'" . default) ("\\.x?html?\\'" . emacs) ("\\.pdf\\'" . default))))
 '(org-todo-keywords (quote ((sequence "TODO" "TOCHECK" "|" "DONE"))))
 '(outline-cycle-emulate-tab t)
 '(pop-up-windows nil)
 '(ps-paper-type (quote a4))
 '(ps-print-color-p (quote black-white))
 '(py-smart-indentation nil)
 '(query-user-mail-address nil)
 '(reftex-default-bibliography (quote ("/home/fredz/annemieke_thesis/latex/biblio.bib")))
 '(scroll-bar-mode nil)
 '(server-mode t)
 '(server-raise-frame nil)
 '(server-window nil)
 '(setq require-final-newline t)
 '(speedbar-after-create-hook (quote (speedbar-frame-reposition-smartly)))
 '(speedbar-directory-unshown-regexp "^\\(CVS\\|RCS\\|SCCS\\|\\.[a-zA-Z1-9._-]*\\)\\'")
 '(speedbar-frame-parameters (quote ((minibuffer) (width . 20) (border-width . 0) (menu-bar-lines . 0) (tool-bar-lines . 0) (unsplittable . t) (left-fringe . 0) (scroll-bar-mode . -1))))
 '(speedbar-query-confirmation-method (quote none-but-delete))
 '(speedbar-supported-extension-expressions (quote (".[ch]\\(\\+\\+\\|pp\\|c\\|h\\|xx\\)?" ".tex\\(i\\(nfo\\)?\\)?" ".el" ".js" ".css" ".sh" ".po" ".css" ".dtml" ".phps?" ".py" ".sql" ".pgml" ".rst" ".rules" ".mak" ".conf" ".s?html" ".csv" ".lst" ".txt" "[Mm]akefile\\(\\.in\\)?")))
 '(speedbar-tag-hierarchy-method nil)
 '(standard-indent 4)
 '(tab-width 4)
 '(tex-dvi-view-command (quote xdvi))
 '(tool-bar-mode nil)
 '(tramp-default-method "ssh")
 '(user-full-name "Frederic de Zorzi")
 '(user-mail-address "fredz@pimentech.fr")
 '(vc-annotate-background "#3b3b3b")
 '(vc-annotate-color-map (quote ((20 . "#dd5542") (40 . "#CC5542") (60 . "#fb8512") (80 . "#baba36") (100 . "#bdbc61") (120 . "#7d7c61") (140 . "#6abd50") (160 . "#6aaf50") (180 . "#6aa350") (200 . "#6a9550") (220 . "#6a8550") (240 . "#6a7550") (260 . "#9b55c3") (280 . "#6CA0A3") (300 . "#528fd1") (320 . "#5180b3") (340 . "#6380b3") (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(whitespace-style (quote (tabs trailing space-before-tab space-after-tab tab-mark))))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "#1e2320" :foreground "#f0dfaf" :height 1.0)))))
