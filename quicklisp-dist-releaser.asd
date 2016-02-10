;;;; quicklisp-dist-releaser.asd

(asdf:defsystem #:quicklisp-dist-releaser
  :description "Convenient functions for releasing Quicklisp dists."
  :author "Zach Beane <zach@quicklisp.org>"
  :license "MIT"
  :depends-on (#:quicklisp-dist)
  :serial t
  :components ((:file "package")
               (:file "quicklisp-dist-releaser")))

