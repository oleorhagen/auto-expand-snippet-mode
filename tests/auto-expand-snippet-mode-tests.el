;;; auto-expand-snippet-mode-tests.el --- Simple snippet expander on <space>, -*- lexical-binding: t -*-
;;; -*- read-symbol-shorthands: (("aes-" . "auto-expand-snippet-")) -*-

;;
;;; Simple unit tests for the mode
;;

(require 'ert)

(require 'auto-expand-snippet-mode)


(ert-deftest test-aes--is-xpander-key-p ()
  "Tests that the xpander-key predicate functions as expected"
  (with-temp-buffer
    (insert "foobar")
    (should-not (auto-expand-snippet--is-xpander-key-p))
    (insert " ,def ")
    (should (auto-expand-snippet--is-xpander-key-p))))


(ert-deftest test-aes-current-word-is-a-snippet ()
  "Tests that the sentinel for whether a snippet exists works"
  (with-temp-buffer
    (emacs-lisp-mode)
    (insert "a") ;; The and template
    (should (auto-expand-snippet--current-word-is-a-snippet-p))))


(ert-test-erts-file "auto-expand-snippet-mode-tests.erts")

(provide 'test-auto-expand-snippet-mode)
