;;; auto-expand-snippet-mode.el --- Simple snippet expander on <space>, -*- lexical-binding: t -*-
;;; -*- read-symbol-shorthands: (("aes-" . "auto-expand-snippet-")) -*-

;; Copyright (C) 2025 Ole P. Orhagen

;; Author: Ole P. Orhagen <ole<at>orhagen.no>
;; Keywords: yasnippet, autocomplete
;; Homepage: https://github.com/oleorhagen/auto-expand-snippet-mode/

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; These definitions let you interact with Prolog in all buffers.
;; You can consult Prolog programs and evaluate embedded queries.

;; Installation
;; ============
;;
;; Copy auto-expand-snippet-mode.el to your load-path and add to your .emacs:
;;
;;     (require 'auto-expand-snippet-mode)
;;     (auto-expand-snippet-mode)
;;
;; Restart Emacs and customize auto-expand-snippet-mode with
;;
;;     M-x customize-group RET auto-expand-snippet-mode RET
;;
;; The two most important configuration options are:
;;
;;    - `auto-expand-snippet-remove-comma-on-snippet-not-found', whether or not to
;;    - remove the prefix comma if no snippet is found

;; Usage
;; =====
;;
;;
;;; A simple minor-mode for automatically expanding snippets, expanded by a
;;; prefix , (comma), and then the snippet name. Expanded once the first space
;;; after the pattern is found.
;;
;;; Real handy for quickly expanding snippets you use a lot.
;;
;;

;; Tested with Yasnippet, and ert,
;; using Emacs versions 29.x

;;; Code:

(defun aes--is-xpander-key-p  ()
  "Checks if the preceding word matches the expected <space>,<snippet><space> pattern"
  (interactive)
  (looking-back ",\\w+ " (point-at-bol)))


(defun aes--current-word-is-a-snippet-p ()
  "Checks if the current word in the pattern is a snippet"
  (interactive)
  (save-excursion
    (backward-char)
    (member (word-at-point t) (yas-active-keys))))


(defun aes--prepare-word ()
  "Remove the surrounding pattern <space> and <comma>, before expanding the snippet"
  (save-excursion
    (backward-char)     ;; Back to the beginning of the word
    (delete-char 1)     ;; Delete the prefix <space>
    (backward-word)     ;; Step back over the word itself
    (backward-char)     ;; Back to over the comma
    (delete-char 1)     ;; Delete the comma
    (forward-word)))


(defun aes--is-single-comma ()
  "Sentinel for the single comma pattern: <space><,><space>"
  (interactive)
  (looking-back " , "))

(defun aes-try-n-xpand-word ()
  "Expands the snippet if the previous text matches the pattern as
set out by aes--is-xpander-key-p, and the word is a yasnippet
snippet."
  (interactive)
  (cond ((and (derived-mode-p 'prog-mode)
              (equal (string (char-before)) " ") ;; Only try-and-xpand on the last <space> insert
              (aes--is-xpander-key-p)
              (aes--current-word-is-a-snippet-p) ;; Only run the body when the word is a snippet
              )
         (aes--prepare-word)
         (evil-insert-state)       ;; Back over the space
         (yas-expand))
        ((aes--is-single-comma)
         (delete-backward-char 3) ;; Delete the whole pattern '<space><comma><space>'
         (yas-insert-snippet)))) ;; Enter insert

;;;###autoload
(define-minor-mode auto-expand-snippet-mode
  "If enabled, expands snippets automatically from Yasnippet if prefixed with comma"
  :lighter "XPand"
  :require '( evil yasnippet )
  :global nil
  :version "1.0.0"
  (if auto-expand-snippet-mode
      (progn
        ;; When enabling the minor mode
        (add-hook 'post-self-insert-hook 'mes-try-n-xpand-word)
        (message "My expand snippet mode enabled."))
    ;; When disabling the minor mode
    (remove-hook 'post-self-insert-hook 'mes-try-n-xpand-word)
    (message "My expand snippet mode disabled.")))

(provide 'auto-expand-snippet-mode)

;; Local Variables:
;; read-symbol-shorthands: (("aes-" . "auto-expand-snippet-"))
;; End:
