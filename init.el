; sudo apt-get install ghc-mod
; font / -size and flymake colors set up by gui means (see custom)
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
                      clojure-mode
                      clojure-test-mode
                      nrepl
                      zenburn-theme
                      jedi
                      key-chord
                      evil
                      multi-term
                      helm
                      ace-jump-mode
                      haskell-mode
                      flymake-haskell-multi
                      lusty-explorer
                      pabbrev
                      highlight-parentheses
                      paredit
                      desktop
                      ))

(dolist (p my-packages)
    (when (not (package-installed-p p))
          (package-install p)))


;______________________________________________________________
;=== MAJOR MODES ==============================================
;______________________________________________________________
(load-theme 'zenburn t)
(evil-mode 1)
(key-chord-mode 1)

;(setq ido-enable-flex-matching t)
;(setq ido-everywhere t)
;(ido-mode 1)
;(global-highlight-changes-mode t)

; NOT TOO SURE
; (add-hook 'python-mode-hook 'auto-complete-mode)
; (add-hook 'python-mode-hook 'jedi:ac-setup)
; 
; (add-hook 'python-mode-hook 'jedi:setup)
; (setq jedi:setup-keys t)
; (setq jedi:complete-on-dot t)

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
(add-to-list 'load-path "/usr/bin/ghc-mod")
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

(defalias 'yes-or-no-p 'y-or-n-p)

(desktop-save-mode 1)
(defun my-desktop-save ()
  (interactive)
  ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
  (if (eq (desktop-owner) (emacs-pid))
      (desktop-save desktop-dirname)))
(add-hook 'auto-save-hook 'my-desktop-save)

(put 'dired-find-alternate-file 'disabled nil)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
;(setq inhibit-default-init t)
(global-hl-line-mode 1)
(setq make-backup-files t)
(line-number-mode 1)
;(linum-mode 1)
;(setq linum-format "%d ")
(column-number-mode 1)
(show-paren-mode 1)
;(electric-pair-mode 1)

;______________________________________________________________
;=== KEYBINDINGS ==============================================
;______________________________________________________________

; probably should set it to Ctrl-j ???
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)

(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-j") 'newline-and-indent)
(global-set-key (kbd "C-j") 'haskell-newline-and-indent)
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



;______________________________________________________________
;=== CUSTOMS (FONT & THEME) SET AUTOMATIC =====================
;______________________________________________________________
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("c5207e7b8cc960e08818b95c4b9a0c870d91db3eaf5959dd4eba09098b7f232b" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
