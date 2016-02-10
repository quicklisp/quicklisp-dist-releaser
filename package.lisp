;;;; package.lisp

(defpackage #:quicklisp-dist-releaser
  (:use #:cl #:commando)
  (:export #:check
           #:release))

