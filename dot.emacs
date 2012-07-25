;; -*- mode: Emacs-Lisp -*-
;; written by k-okada 2006.06.14
;;
;; changed by ueda 2009.04.21

;; (debian-startup 'emacs21)

;;; Global Setting Key
;;;
(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\M-g" 'goto-line);
(global-unset-key "\C-o" )

(setq visible-bell t)

;;; When in Text mode, want to be in Auto-Fill mode.
;;;
(defun my-auto-fill-mode nil (auto-fill-mode 1))
(setq text-mode-hook 'my-auto-fill-mode)
(setq mail-mode-hook 'my-auto-fill-mode)

;;; time
;;;
(load "time" t t)
(display-time)

;;;	for mew
;;;
;;;     explanation exists in /opt/src/Solaris/mew-1.03/00install.jis
;;;

(autoload 'mew "mew" nil t)
(autoload 'mew-read "mew" nil t)
(autoload 'mew-send "mew" nil t)

(setq mew-name "User Name")
(setq mew-user "user")
(setq mew-dcc "user@jsk.t.u-tokyo.ac.jp")

(setq mew-mail-domain "jsk.t.u-tokyo.ac.jp")
(setq mew-pop-server "mail.jsk.t.u-tokyo.ac.jp")
(setq mew-pop-auth 'apop)
(setq mew-pop-delete 3)
(setq mew-smtp-server "mail.jsk.t.u-tokyo.ac.jp")
(setq mew-fcc nil)
(setq mew-use-cached-passwd t)

;;
;; Optional setup (Read Mail menu for Emacs 21):
(if (boundp 'read-mail-command)
    (setq read-mail-command 'mew))

;; Optional setup (e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))

(define-key ctl-x-map "r" 'mew)
(define-key ctl-x-map "m" 'mew-send)

;; (lookup)
;;
(setq lookup-search-agents '((ndtp "nfs")))
(define-key global-map "\C-co" 'lookup-pattern)
(define-key global-map "\C-cr" 'lookup-region)
(autoload 'lookup "lookup" "Online dictionary." t nil )

;; Japanese
;; uncommented by ueda. beacuse in shell buffer, they invokes mozibake
(set-language-environment 'Japanese)
(set-default-coding-systems 'iso-2022-jp)
(setq default-process-coding-system '(euc-japan-unix . euc-japan-unix))
(if (not window-system)
    (set-terminal-coding-system 'euc-japan))
(setq enable-double-n-syntax t)

(setq use-kuten-for-period nil)
(setq use-touten-for-comma nil)

(load-library "yc")

;;; Timestamp
;;;
(defun timestamp-insert ()
  (interactive)
  (insert (current-time-string))
  (backward-char))
(global-set-key "\C-c\C-d" 'timestamp-insert)

(global-font-lock-mode t)

;; M-n and M-p
(global-unset-key "\M-p")
(global-unset-key "\M-n")

(defun scroll-up-in-place (n)
       (interactive "p")
       (previous-line n)
       (scroll-down n))


(defun scroll-down-in-place (n)
       (interactive "p")
       (next-line n)
       (scroll-up n))

(global-set-key "\M-n" 'scroll-down-in-place)
(global-set-key "\M-p" 'scroll-up-in-place)

;; dabbrev
(global-set-key "\C-o" 'dabbrev-expand)

;; add by kojima
(require 'paren)
(show-paren-mode 1)
;; ;; C-qで移動
(defun match-paren (arg)
  "Go to the matching parenthesis if on parenthesis."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
	((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        )
  )
(global-set-key "\C-q" 'match-paren)


(font-lock-add-keywords 'lisp-mode
	                (list
		          (list "\\(\\*\\w\+\\*\\)\\>"
			        '(1 font-lock-constant-face nil t))
		          (list "\\(\\+\\w\+\\+\\)\\>"
			        '(1 font-lock-constant-face nil t))))

;; does not allow use hard tab.
(add-hook 'lisp-mode-hook
	  (lambda ()
	     (setq indent-tabs-mode nil)))

(add-hook 'c-mode-common-hook
	  (lambda ()
	     (setq indent-tabs-mode nil)))

;; ignore start message
(setq inhibit-startup-message t)

;; add template.l by kojima
(require 'autoinsert)
(when (featurep 'emacs)
  (let (skeldir)
    (setq skeldir "~/prog/scripts/")
    (setq auto-insert-directory skeldir)
    (setq auto-insert-alist
	  (nconc '(
		   ("\\.l$" . "template.l")
		   ("\\.sh$" . "template.sh")
		   ("Makefile$" . "template.Makefile")
		   ("\\.cpp$" . "template.cpp")
		   ("\\.h$" . "template.h")
		    ) auto-insert-alist))
    (add-hook 'find-file-not-found-hooks 'auto-insert)
    )
  )

;; shell mode
;;(set-terminal-coding-system 'utf-8)
;;(set-buffer-file-coding-system 'utf-8)
(setq explicit-shell-file-name shell-file-name)
(setq shell-command-option "-c")
(setq system-uses-terminfo nil)
(setq shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@`'.,:()-")
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


(defun lisp-other-window ()
  "Run Lisp on other window"
  (interactive)
  (switch-to-buffer-other-window
   (get-buffer-create "*inferior-lisp*"))
  (run-lisp inferior-lisp-program))

(set-variable 'inferior-lisp-program "jskrbeusgl")
(global-set-key "\C-cE" 'lisp-other-window)

;; space,tab,全角 space に色をつける
;;(defface my-face-b-1 '((t (:background "gray"))) nil)
(defface my-face-b-2 '((t (:background "red"))) nil)
(defface my-face-u-1 '((t (:background "red"))) nil)
;;(defvar my-face-b-1 'my-face-b-1)
(defvar my-face-b-2 'my-face-b-2)
(defvar my-face-u-1 'my-face-u-1)

(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(
     ;;("\t" 0 my-face-b-1 append)
     ("　" 0 my-face-b-2 append)
     ("[ \t]+$" 0 my-face-u-1 append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)

(setq default-frame-alist
      (append (list '(foreground-color . "green")
		    '(background-color . "black")
		    '(border-color . "blue")
		    '(mouse-color . "white")
		    )
	      default-frame-alist)
      )
(menu-bar-mode 0)
(tool-bar-mode 0)

;;(add-to-list 'load-path (substring (shell-command-to-string "rospack find rosemacs") 0 -1))
;;(require 'rosemacs)
;;(invoke-rosemacs)
;;(global-set-key "\C-x\C-r" ros-keymap)


(setq truncate-lines nil)
(setq truncate-partial-width-windows nil)
(setq text-mode-hook 'turn-off-auto-fill)

;;for rosemacs
(push "/opt/ros/electric/ros/tools/rosemacs" load-path)
(require 'rosemacs)
(invoke-rosemacs)
(global-set-key "\C-x\C-r" ros-keymap)

;;for auto-complete
(setq ac-dir "/home/leus/.emacs.d/auto-complete-1.3.1")
(add-to-list 'load-path ac-dir)
(require 'auto-complete-config)
(ac-config-default)

;; (add-to-list 'ac-dictionary-directories (concat ac-dir "ac-dict/"))
;; ;;(global-set-key "\M-/" 'ac-start)
;; (global-set-key "\C-" 'ac-start)
;; ;; C-n/C-p で候補を選択
;; (define-key ac-complete-mode-map "\C-n" 'ac-next)
;; (define-key ac-complete-mode-map "\C-p" 'ac-previous)

;;for-auto-complete-clang
(require 'auto-complete-clang)
(defun my-ac-cc-mode-setup ()
  ;; 読み込むプリコンパイル済みヘッダ
  (setq ac-clang-prefix-header "stdafx.pch")
  ;; 補完を自動で開始しない
  ;;(setq ac-auto-start nil)
  ;; 補完を自動で開始する
  (setq ac-auto-start t)
  (setq ac-clang-flags '("-w" "-ferror-limit" "1"))
  (setq ac-sources (append '(ac-source-clang
                             ac-source-yasnippet
                             ac-source-gtags)
                           ac-sources)))
(defun my-ac-config ()
  (global-set-key "\M-/" 'ac-start)
  ;;(global-set-key "\C-\;" 'ac-start)
  ;; C-n/C-p で候補を選択
  (define-key ac-complete-mode-map "\C-n" 'ac-next)
  (define-key ac-complete-mode-map "\C-p" 'ac-previous)
  (add-hook 'emacs-lisp-mode-hook 'ac-emacs-lisp-mode-setup)
  (add-hook 'lisp-mode-hook 'ac-emacs-lisp-mode-setup)
  (add-hook 'c-mode-common-hook 'my-ac-cc-mode-setup)
  (add-hook 'ruby-mode-hook 'ac-css-mode-setup)
  (add-hook 'auto-complete-mode-hook 'ac-common-setup)
  (global-auto-complete-mode t))

(my-ac-config)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; For folding
;;;

;; C coding style
(add-hook 'c-mode-hook
          '(lambda ()
    (hs-minor-mode 1)
    (hs-hide-all)))
;; C++ coding style
(add-hook 'c++-mode-hook
          '(lambda ()
    (hs-minor-mode 1)
    (hs-hide-all)))
;; Scheme coding style
(add-hook 'scheme-mode-hook
          '(lambda ()
    (hs-minor-mode 1)))
;; Elisp coding style
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
    (hs-minor-mode 1)))
;; Lisp coding style
(add-hook 'lisp-mode-hook
          '(lambda ()
    (hs-minor-mode 1)
    (hs-hide-all)))
;; Python coding style
(add-hook 'python-mode-hook
          '(lambda ()
    (hs-minor-mode 1)))

(define-key
  global-map
  (kbd "C-#") 'hs-toggle-hiding)