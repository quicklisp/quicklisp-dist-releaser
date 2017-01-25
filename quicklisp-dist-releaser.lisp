;;;; quicklisp-dist-releaser.lisp

(in-package #:quicklisp-dist-releaser)

;;; "quicklisp-dist-releaser" goes here. Hacks and glory await!

(defvar *site-directory*
  "~/src/quicklisp-site/")

(defvar *projects-directory*
  "~/src/quicklisp-projects/")

(defun check ()
  (flet ((check-directory (value)
           (unless (probe-file value)
             (error "Directory ~A missing" value))))
    (check-directory *projects-directory*)
    (check-directory *site-directory*)))

(defun git (&rest args)
  (apply #'run "git" args))

(defun git-lines (&rest args)
  (apply #'run-output-lines "git" args))

(defun git-clean-p ()
  (null (git-lines "status" "--porcelain"
                   "--untracked-files=no")))

(defun update-site ()
  (with-posix-cwd *site-directory*
    (git "pull")
    (release-report:release-report "quicklisp" "beta/releases.html")
    (unless (git-clean-p)
      ;; releases.html has changed
      (git "add" "beta/releases.html")
      (git "commit" "-m"
           (format nil "Update releases.html for version ~A"
                   (ql:dist-version "quicklisp")))
      (git "push"))))

(defun install-latest-everything ()
  (ql:update-dist "quicklisp" :prompt nil)
  (map nil 'ql-dist:ensure-installed
       (ql-dist:provided-releases (ql-dist:dist "quicklisp"))))

(defun release (&key skip)
  (install-latest-everything)
  (update-site)
  (with-posix-cwd *projects-directory*
    (git "pull"))
  (update-report:dist-update-report "quicklisp" :skip skip))
