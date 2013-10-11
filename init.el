; sudo apt-get install ghc-mod
; font / -size and flymake colors set up by gui means (see custom)
; [dejavu, andale, menlo, droid, {monaco, bitstream railscasts&peepco}]
; wanderlust for gmail email
; or even gnus for some simple refefe reading ;)
; w3m ???
; http://vimeo.com/13158054
; erc for irc
; org-mode way to might might as well have a more thorough lock at it
; ritz??? even better than nrepl for clojure debugging
; if rsense: http://itstickers.blogspot.de/2010/11/all-about-emacs.html
; very good .emacs https://gist.github.com/mig/785133 !!!!!!!!!!!!!!!!!!!
; the same + docu as: http://viget.com/extend/emacs-24-rails-development-environment-from-scratch-to-productive-in-5-minu
; other one by batsov: http://batsov.com/articles/2008/06/19/emacs-rails/
; TODO pabbrev fixen (void-function pabbrev)???

;______________________________________________________________
;=== INITIALIZATION ===========================================
;______________________________________________________________
(require 'package)
(add-to-list 'package-archives
             ;'("marmalade" . "http://marmalade-repo.org/packages/")
             ;'("gnu" . "http://elpa.gnu.org/packages/")
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

; SET AFTER MIGRATION OR ADDING NEW PACKAGE!!!
(package-refresh-contents)

(defvar my-packages '(starter-kit
                      starter-kit-lisp
                      starter-kit-bindings
                      starter-kit-eshell
                      ; SYSTEM
                      zenburn-theme
                      solarized-theme
                      ;ecb
                      key-chord
                      evil
                      multi-term
                      desktop
                      highlight-parentheses
                      ;w3m
                      emms
                      ;textmate
                      ; NAVIGATION
                      ace-jump-mode
                      helm
                      lusty-explorer
                      paredit
                      ;projectile
                      ; CLOJURE
                      clojure-mode
                      clojure-test-mode
                      nrepl
                      ac-nrepl
                      ; PYTHON
                      jedi
                      ; HASKELL
                      haskell-mode
                      flymake-haskell-multi
                      ; AUTOCOMPLETE
                      company
                      company-inf-ruby
                      pabbrev
                      popup
                      ;autopair-mode
                      yasnippet
                      ; RUBY
                      ;rsense ; nah ... what does rsense auto-complete cant
                      inf-ruby
                      rinari
                      ruby-compilation
                      yari
                      robe
                      ;rvm???
                      ; WEB
                      ;nxhtml-mode
                      rhtml-mode
                      css-mode
                      ; DATA
                      ;yaml-mode
                      ))

(dolist (p my-packages)
    (when (not (package-installed-p p))
          (package-install p)))

; additional HUGE package including but not limited to jedi python autocomplete
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))
(el-get 'sync)
;(setenv "PYTHONPATH" "/usr/bin/python")

;; Setting rbenv path for ruby
;; (setenv "PATH" (concat (getenv "HOME") "/.rbenv/shims:" (getenv "HOME") "/.rbenv/bin:" (getenv "PATH")))
;; (setq exec-path (cons (concat (getenv "HOME") "/.rbenv/shims") (cons (concat (getenv "HOME") "/.rbenv/bin") exec-path)))

(setenv "PATH" (concat (getenv "HOME") "/.rbenv/shims:" (getenv "HOME") "/.rbenv/bin:" (getenv "PATH")))
(setq exec-path (cons (concat (getenv "HOME") "/.rbenv/shims") (cons (concat (getenv "HOME") "/.rbenv/versions/2.0.0-p247/bin") exec-path)))


; as seen here: http://viget.com/extend/emacs-24-rails-development-environment-from-scratch-to-productive-in-5-minu
(push "/usr/local/bin" exec-path)
; oder???
;(push "/usr/bin" exec-path)

(require 'emms-setup)
          (emms-all)
          (emms-default-players)

(define-emms-simple-player mplayer '(file url)
      (regexp-opt '(".ogg" ".mp3" ".wav" ".mpg" ".mpeg" ".wmv" ".wma"
                    ".mov" ".avi" ".divx" ".ogm" ".asf" ".mkv" "http://" "mms://"
                    ".rm" ".rmvb" ".mp4" ".flac" ".vob" ".m4a" ".flv" ".ogv" ".pls"))
      "mplayer" "-slave" "-quiet" "-really-quiet" "-fullscreen")
;______________________________________________________________
;=== MAJOR MODES ==============================================
;______________________________________________________________
; oder tango theme?
;(load-theme 'zenburn t)
(load-theme 'solarized-light)
(evil-mode 1)
(key-chord-mode 1)

; https://github.com/dgutov/robe
(add-hook 'ruby-mode-hook 'robe-mode)
;(push 'company-robe company-backends)
;(push 'ac-source-robe ac-sources)

; auto-complete with documentation popup
(require 'auto-complete-config)
(ac-config-default)
; http://marmalade-repo.org/packages/yari
(defun ri-bind-key () (local-set-key [f1] 'yari))
(add-hook 'ruby-mode-hook 'ri-bind-key)

; https://github.com/purcell/emacs.d/blob/master/init-auto-complete.el
(global-auto-complete-mode t)
;; (setq ac-expand-on-auto-complete nil)
;; (setq ac-auto-start nil)
;; (setq ac-dwim nil) ; To get pop-ups with docs even if a word is uniquely completed
;; (setq tab-always-indent 'complete) ;; use 't when auto-complete is disabled
;; (add-to-list 'completion-styles 'initials t)
;; (set-default 'ac-sources
;;              '(ac-source-imenu
;;                ac-source-dictionary
;;                ac-source-words-in-buffer
;;                ac-source-words-in-same-mode-buffers
;;                ac-source-words-in-all-buffer))

;; (dolist (mode '(magit-log-edit-mode log-edit-mode org-mode text-mode haml-mode
;;                 sass-mode yaml-mode csv-mode espresso-mode haskell-mode
;;                 html-mode nxml-mode sh-mode smarty-mode clojure-mode
;;                 lisp-mode textile-mode markdown-mode tuareg-mode
;;                 js3-mode css-mode less-css-mode sql-mode ielm-mode))
;;   (add-to-list 'ac-modes mode))

(define-key ac-completing-map "\M-/" 'ac-stop) ; use M-/ to stop completion
(require 'ac-nrepl)
(add-hook 'nrepl-mode-hook 'ac-nrepl-setup)
(add-hook 'nrepl-interaction-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete" '(add-to-list 'ac-modes 'nrepl-mode))

;(setq ido-enable-flex-matching t)
;(setq ido-everywhere t)
;(ido-mode 1)
;(global-highlight-changes-mode t)

; NOT TOO SURE
;; (add-hook 'python-mode-hook 'auto-complete-mode)
;; (add-hook 'python-mode-hook 'jedi:ac-setup)

;; (add-hook 'python-mode-hook 'jedi:setup)
;; (setq jedi:setup-keys t)
;; (setq jedi:complete-on-dot t)

(define-globalized-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  (lambda ()
    (highlight-parentheses-mode t)))
(global-highlight-parentheses-mode t)
(paredit-mode t)
(setq hl-paren-colors
'("red1" "orange1" "yellow1" "green1" "cyan1"
"slateblue1" "magenta1" "purple"))

;(global-pabbrev-mode)
(setq pabbrev-read-only-error nil)
;(setq pabbrev-minimal-expansion-p t)
(add-hook 'text-mode-hook (lambda () (pabbrev-mode 1)))
(setq x-stretch-cursor t)
(setq-default indent-tabs-mode nil)

; HASKELL
;(add-to-list 'load-path "/usr/bin/ghc-mod")
(add-to-list 'load-path "~/.cabal/bin/ghc-mod")
;(add-to-list 'load-path "/home/marten/.emacs.d/elpa/flymake-haskell-multi-master")
;(add-to-list 'load-path "/home/marten/.emacs.d/elpa/flymake-easy-master")
(add-to-list 'exec-path "~/.cabal/bin")
(require 'flymake-haskell-multi)
(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))
(add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-haskell-multi-load)))
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;(setq inferior-lisp-program "lein repl")


;______________________________________________________________
;=== WINDOW BEHAVIOUR =========================================
;______________________________________________________________
(setq scroll-margin 10)
(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)
(add-hook 'term-mode-hook
          (lambda()
            (set (make-local-variable 'scroll-margin) 0)))

(desktop-save-mode 1)
(defun my-desktop-save ()
  (interactive)
  ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
  (if (eq (desktop-owner) (emacs-pid))
      (desktop-save desktop-dirname)))
(add-hook 'auto-save-hook 'my-desktop-save)

(put 'dired-find-alternate-file 'disabled nil)

;(tool-bar-mode -1)
(menu-bar-mode -1)
;(scroll-bar-mode -1)
;(blink-cursor-mode -1)
;(setq inhibit-default-init t)
(global-hl-line-mode 1)
;(setq make-backup-files t)

; as seen here: http://viget.com/extend/emacs-24-rails-development-environment-from-scratch-to-productive-in-5-minu
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-message t)
(fset 'yes-or-no-p 'y-or-n-p)
;(defalias 'yes-or-no-p 'y-or-n-p)
(delete-selection-mode t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode t)
(show-paren-mode t)
(column-number-mode t)
(set-fringe-style -1)
(tooltip-mode -1)

(line-number-mode 1)
;(linum-mode 1)
;(setq linum-format "%d ")
(column-number-mode 1)
;(show-paren-mode 1)


(electric-pair-mode t)
(global-linum-mode t)
(electric-indent-mode t)

;______________________________________________________________
;=== KEYBINDINGS ==============================================
;______________________________________________________________

; probably should set it to Ctrl-j ???
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)

(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-j") 'newline-and-indent)
;(global-set-key (kbd "C-j") 'haskell-newline-and-indent)
(global-set-key (kbd "M-SPC") 'hippie-expand)
(setq hippie-expand-try-functions-list '(try-expand-dabbrev try-expand-dabbrev-all-buffers try-expand-dabbrev-from-kill try-complete-file-name-partially try-complete-file-name try-expand-all-abbrevs try-expand-list try-expand-line try-complete-lisp-symbol-partially try-complete-lisp-symbol))


(global-set-key (kbd "C-x a r") 'align-regexp)
(global-set-key (kbd "<C-tab>") 'other-window)
(global-set-key (kbd "C-,") 'lusty-buffer-explorer)
(global-set-key (kbd "C-c h") 'helm-mini)
;(global-set-key (kbd "<C-tab>") 'bury-buffer)
;(global-set-key (kbd "<C-S-tab>") 'previous-buffer)

(when (require 'lusty-explorer nil 'noerror)
  ;; overrride the normal file-opening, buffer switching
  (global-set-key (kbd "C-x C-f") 'lusty-file-explorer)
  (global-set-key (kbd "C-x b")   'lusty-buffer-explorer))
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-+") 'delete-other-windows)
(global-set-key (kbd "C-#") 'split-window-horizontally)

(global-set-key (kbd "C-x C-l") 'windmove-right)
(global-set-key (kbd "C-x C-h") 'windmove-left)
(global-set-key (kbd "C-x C-k") 'windmove-up)
(global-set-key (kbd "C-x C-j") 'windmove-down)
(global-set-key (kbd "C-c C-t") 'multi-term)

; C-M-AltGr-ß
; M-z zap to char (auch im evil-mode und auch M-z " ")
; mark-region yank search paste in search minibuffer ;)

; https://sites.google.com/site/steveyegge2/effective-emacs
; doesnt work just switches to shell?????
;; (global-set-key "\C-x\C-m" 'execute-extended-command)
;; (global-set-key "\C-c\C-m" 'execute-extended-command)

; C-x C-+ upsize font C-x C-0 back to normal


(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)
(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)
(define-key global-map (kbd "C-i") 'ace-jump-mode)

(global-set-key (kbd "C-x F") 'djcb-find-file-as-root)

; M-; comment-region
; use a instead of RET in dired so dired buffer is reused aka only 1
; buffer for dired
; M-m back-to-indentation (like C-a)

;______________________________________________________________
;=== FUNCTIONS ================================================
;______________________________________________________________
(setq tmux-session-name "dev")
(setq tmux-window-name 1)
(setq tmux-pane-number 0)

(defun tmux-exec (command)
  "Execute command in tmux pane"
  (interactive)
  (shell-command
    (format "tmux send-keys -t %s:%s.%s '%s' Enter" tmux-session-name tmux-window-name tmux-pane-number command)))

(defun tmux-exec-elinks ()
  "Execute 'bundle exec cucumber' in tmux pane"
  (interactive)
  (tmux-exec "elinks http://127.0.0.1"))

(defun tmux-setup (x y z)
  "Setup global variables for tmux session, window, and pane"
  (interactive "sEnter tmux session name: \nsEnter tmux window name: \nsEnter tmux pane number: ")
  (setq tmux-session-name x)
  (setq tmux-window-name y)
  (setq tmux-pane-number z)
  (message "Tmux Setup, session name: %s, window name: %s, pane number: %s" tmux-session-name tmux-window-name tmux-pane-number))

;; (defun pabbrev-suggestions-ido (suggestion-list)
;;     "Use ido to display menu of all pabbrev suggestions."
;;       (when suggestion-list
;;             (pabbrev-suggestions-insert-word pabbrev-expand-previous-word)
;;                 (pabbrev-suggestions-insert-word
;;                        (ido-completing-read "Completions: " (mapcar 'car suggestion-list)))))

;; (defun pabbrev-suggestions-insert-word (word)
;;     "Insert word in place of current suggestion, with no attempt to kill pabbrev-buffer."
;;       (let ((point))
;;             (save-excursion
;;                     (let ((bounds (pabbrev-bounds-of-thing-at-point)))
;;                         (progn
;;                               (delete-region (car bounds) (cdr bounds))
;;                                   (insert word)
;;                                       (setq point (point)))))
;;                 (if point
;;                     (goto-char point))))

;; (fset 'pabbrev-suggestions-goto-buffer 'pabbrev-suggestions-ido)

; as seen here: http://emacs-fu.blogspot.de/2013/03/editing-with-root-privileges-once-more.html
(defun djcb-find-file-as-root ()
 "Like `ido-find-file, but automatically edit the file with root-privileges (using tramp/sudo), if the file is not writable by user."
 (interactive)
 (let ((file (ido-read-file-name "Edit as root: ")))
   (unless (file-writable-p file)
     (setq file (concat "/sudo:root@localhost:" file)))
   (find-file file)))


;______________________________________________________________
;=== CUSTOMS (FONT & THEME) SET AUTOMATIC =====================
;______________________________________________________________
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "62b86b142b243071b5adb4d48a0ab89aefd3cf79ee3adc0bb297ea873b36d23f" "c5207e7b8cc960e08818b95c4b9a0c870d91db3eaf5959dd4eba09098b7f232b" default)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "unknown" :slant normal :weight normal :height 98 :width normal)))))
