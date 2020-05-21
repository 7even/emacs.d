;;;;
;; Packages
;;;;

;; Define package repositories
(require 'package)
;; (add-to-list 'package-archives
;;              '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("tromey" . "http://tromey.com/elpa/") t)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
;;                          ("marmalade" . "http://marmalade-repo.org/packages/")
;;                          ("melpa" . "http://melpa-stable.milkbox.net/packages/")))


;; Load and activate emacs packages. Do this first so that the
;; packages are loaded before you start trying to modify them.
;; This also sets the load path.
(package-initialize)

;; Download the ELPA archive description if needed.
;; This informs Emacs about the latest versions of all packages, and
;; makes them available for download.
(when (not package-archive-contents)
  (package-refresh-contents))

;; Define he following variables to remove the compile-log warnings
;; when defining ido-ubiquitous
(defvar ido-cur-item nil)
(defvar ido-default-item nil)
(defvar ido-cur-list nil)
(defvar predicate nil)
(defvar inherit-input-method nil)

;; The packages you want installed. You can also install these
;; manually with M-x package-install
;; Add in your own as you wish:
(defvar my-packages
  '(;; makes handling lisp expressions much, much easier
    ;; Cheatsheet: http://www.emacswiki.org/emacs/PareditCheatsheet
    paredit

    ;; key bindings and code colorization for Clojure
    ;; https://github.com/clojure-emacs/clojure-mode
    clojure-mode

    ;; extra syntax highlighting for clojure
    clojure-mode-extra-font-locking

    ;; integration with a Clojure REPL
    ;; https://github.com/clojure-emacs/cider
    cider

    ;; allow ido usage in as many contexts as possible. see
    ;; customizations/navigation.el line 23 for a description
    ;; of ido
    ido-ubiquitous

    ;; Enhances M-x to allow easier execution of commands. Provides
    ;; a filterable list of possible commands in the minibuffer
    ;; http://www.emacswiki.org/emacs/Smex
    smex

    ;; project navigation
    projectile

    ;; colorful parenthesis matching
    rainbow-delimiters

    ;; edit html tags like sexps
    tagedit

    ;; git integration
    magit))

;; On OS X, an Emacs instance started from the graphical user
;; interface will have a different environment than a shell in a
;; terminal window, because OS X does not run a shell during the
;; login. Obviously this will lead to unexpected results when
;; calling external utilities like make from Emacs.
;; This library works around this problem by copying important
;; environment variables from the user's shell.
;; https://github.com/purcell/exec-path-from-shell
(if (eq system-type 'darwin)
    (add-to-list 'my-packages 'exec-path-from-shell))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


;; Place downloaded elisp files in ~/.emacs.d/vendor. You'll then be able
;; to load them.
;;
;; For example, if you download yaml-mode.el to ~/.emacs.d/vendor,
;; then you can add the following code to this file:
;;
;; (require 'yaml-mode)
;; (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
;; 
;; Adding this code will make Emacs enter yaml mode whenever you open
;; a .yml file
(add-to-list 'load-path "~/.emacs.d/vendor")


;;;;
;; Customization
;;;;

;; Add a directory to our load path so that when you `load` things
;; below, Emacs knows where to look for the corresponding file.
(add-to-list 'load-path "~/.emacs.d/customizations")

;; Sets up exec-path-from-shell so that Emacs will use the correct
;; environment variables
(load "shell-integration.el")

;; These customizations make it easier for you to navigate files,
;; switch buffers, and choose options from the minibuffer.
(load "navigation.el")

;; These customizations change the way emacs looks and disable/enable
;; some user interface elements
(load "ui.el")

;; These customizations make editing a bit nicer.
(load "editing.el")

;; Hard-to-categorize customizations
(load "misc.el")

;; For editing lisps
(load "elisp-editing.el")

;; Langauage-specific
(load "setup-clojure.el")
(load "setup-js.el")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(blink-cursor-blinks 0)
 '(blink-cursor-delay 0.2)
 '(cider-boot-parameters "repl -s -b localhost wait")
 '(cider-clojure-cli-parameters "-C:dev -m nrepl.cmdline --middleware '%s'")
 '(cider-repl-display-help-banner nil)
 '(coffee-tab-width 2)
 '(column-number-mode t)
 '(cursor-type (quote bar))
 '(custom-enabled-themes (quote (solarized-light)))
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(mac-command-modifier (quote super))
 '(mac-option-modifier (quote meta))
 '(magit-fetch-arguments (quote ("--prune")))
 '(magit-push-always-verify nil)
 '(nrepl-sync-request-timeout 30)
 '(package-selected-packages
   (quote
    (projectile clojure-mode cider rjsx-mode kubernetes yaml-mode textmate terraform-mode tagedit solarized-theme smex slim-mode shrink-whitespace rainbow-delimiters powerline org magit ido-ubiquitous helm-projectile grizzl expand-region exec-path-from-shell dockerfile-mode company clojure-mode-extra-font-locking clj-refactor ace-window)))
 '(ruby-align-to-stmt-keywords (quote (def if case)))
 '(ruby-insert-encoding-magic-comment nil)
 '(split-height-threshold 200))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(tool-bar-mode -1)

(defun switch-to-previous-buffer ()
  "Switch to most recent buffer. Repeated calls toggle back and forth between the most recent two buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

;; set key binding
(global-set-key (kbd "C-`") 'switch-to-previous-buffer)

(electric-indent-mode +1)

;; (textmate-mode)

(add-hook 'after-init-hook 'global-company-mode)

(global-set-key (kbd "C-x g") 'magit-status)

(with-eval-after-load 'magit
  (magit-change-popup-key 'magit-fetch-popup  :action ?u ?f)
  (magit-change-popup-key 'magit-pull-popup   :action ?u ?F)
  (magit-change-popup-key 'magit-rebase-popup :action ?e ?r)
  (magit-change-popup-key 'magit-push-popup   :action ?p ?P))

;; (toggle-frame-fullscreen)

(global-set-key (kbd "s-r") 'ace-window)
(setq aw-dispatch-always 't)

(global-set-key (kbd "s-1") (kbd "s-r 1"))
(global-set-key (kbd "s-2") (kbd "s-r 2"))
(global-set-key (kbd "s-3") (kbd "s-r 3"))
(global-set-key (kbd "s-4") (kbd "s-r 4"))
(global-set-key (kbd "s-5") (kbd "s-r 5"))
(global-set-key (kbd "s-6") (kbd "s-r 6"))
(global-set-key (kbd "s-7") (kbd "s-r 7"))
(global-set-key (kbd "s-8") (kbd "s-r 8"))
(global-set-key (kbd "s-9") (kbd "s-r 9"))

(global-set-key (kbd "s-k") 'kill-this-buffer)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(global-set-key (kbd "<s-return>") (kbd "C-e C-m"))
(global-set-key (kbd "<S-s-return>") (kbd "C-p C-e C-m"))

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(require 'helm-config)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)

(require 'helm-projectile)
(helm-projectile-on)

;;keep cursor at same position when scrolling
(setq scroll-preserve-screen-position 1)
;;scroll window up/down by one line
(global-set-key (kbd "M-n") (kbd "C-u 1 C-v"))
(global-set-key (kbd "M-p") (kbd "C-u 1 M-v"))

(global-set-key (kbd "M-\\") 'shrink-whitespace)

(global-set-key (kbd "s-u") 'revert-buffer)

(avy-setup-default)
(global-set-key (kbd "s-d") 'avy-goto-word-1)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;; set maximum indentation for description lists
(setq org-list-description-max-indent 5)

;; prevent demoting heading also shifting text inside sections
(setq org-adapt-indentation nil)

(setq org-agenda-files (list "~/org/work.org"))

(setq org-default-notes-file (concat org-directory "/work.org"))
(define-key global-map "\C-cc" 'org-capture)

(setq org-element-use-cache nil)

(delete-selection-mode t)

(eval-after-load 'inf-ruby
  '(define-key inf-ruby-minor-mode-map
     (kbd "C-c C-s") 'inf-ruby-console-auto))

(set-default-font "Fira Code")
(mac-auto-operator-composition-mode)
