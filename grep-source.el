;;
;; grep-source.el
;;

(defun grep-get-search-directory ()
  (let ((directory (file-name-as-directory (read-file-name "Search directory: " nil default-directory))))
    (if (not (file-directory-p directory))
	(error (concat directory " is not a directory")))
    directory)
)

(defun grep-dir ()
  "Search a directory for a string."
  (interactive)
  (let* ((search-string (read-string "Search directory for: " (current-word)))
	(default-directory (grep-get-search-directory))
	(grep-find-command (concat "grep -r -n -e \"" search-string "\" *")))
    (grep-find grep-find-command)
    )
  )

(defun grep-source-get-ext ()
  (cond ((eq major-mode 'c-mode) "-iname \"*.c\" -or -iname \"*.h\"")
	((eq major-mode 'emacs-lisp-mode) "-iname \"*.el\"")
	((eq major-mode 'python-mode) "-iname \"*.py\"")
	((eq major-mode 'c++-mode) "-iname \"*.cpp\" -or -iname \"*.h\"")
	((eq major-mode 'java-mode) "-iname \"*.java\"")
	((eq major-mode 'sawfish-mode) "-iname \"*.jl\"")))

(defun grep-source-criteria ()
  (let ((criteria (grep-source-get-ext)))
    (if (null criteria)
	nil
      (concat "\\( " criteria " \\)"))))

(defun grep-source ()
  "Search source files in a directory for a string."
  (interactive)
  (let* ((search-string (read-string "Search source for: " (current-word)))
	(default-directory (grep-get-search-directory))
	(grep-find-command (concat "find . " (grep-source-criteria) "  -exec grep -n -H -e \"" search-string "\" '{}' \\;")))
    (grep-find grep-find-command)
    )
  )

(global-set-key [(f3)] 'grep-dir)
(global-set-key [(f4)] 'grep-source)
;;
;; End of grep-source.el
;;

;(add-to-list 'load-path "/path/to/full-ack")
(autoload 'ack-same "full-ack" nil t)
(autoload 'ack "full-ack" nil t)
(autoload 'ack-find-same-file "full-ack" nil t)
(autoload 'ack-find-file "full-ack" nil t)
