;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "David Adams"
      user-mail-address "dbadams@iinet.net.au")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;;(setq lsp-pyright-venv-path "/node/bud82/envs/second")

(setq-default
 delete-by-moving-to-trash t ; use systems trashcan
 window-combination-resize t ; take all new space
 x-stretch-cursor t          ; deal with glyphs
 )


(setq
 undo-limit 2000000
 evil-want-fine-undo t          ; make undo limit bigger
 auto-save-default t            ; help with the b-s
 truncate-string-ellipsis "…"   ; is nicer
 )

(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (+ivy/switch-buffer))

(add-to-list 'default-frame-alist '(height . 24)) ; better frame sizing
(add-to-list 'default-frame-alist '(width . 80))  ;


(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (and (memq (plist-get (coding-system-plist buffer-file-coding-system) :category)
                                 '(coding-category-undecided coding-category-utf-8))
                           (not (memq (coding-system-eol-type buffer-file-coding-system) '(1 2))))
                t)))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)
(setq projectile-indexing-method 'native)

(after! flycheck
  (map! :leader
        (:prefix-map ("c" . "code")
         "x" flycheck-command-map)))

(setq meghanada-java-path "/d/sw/java64/jdk-12.0.1/bin/java")
(setq lsp-java-java-path "/d/sw/java64/jdk-12.0.1/bin/java")
(setq conda-anaconda-home "/d/sw/miniconda3/4.8.2/")
