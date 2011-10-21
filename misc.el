
(defun kill-lines-matching-string ()
  (interactive)
  (save-excursion 
    (let ((match (read-input "String to match: ")))
      (beginning-of-buffer)
      (while (search-forward match nil t)
	(kill-whole-line)))))

(defun kill-buffer-by-file ()
  (interactive)
  (let ((str (read-string "Matching what? ")))
    (mapcar (lambda (b) (if (and (buffer-file-name b)
				 (string-match str (buffer-file-name b)))
			    (kill-buffer b))) (buffer-list))))

(defun notes ()
  (interactive)
  (find-file (expand-file-name "Notes/work.org" "~")))


(defun my-org-hook () 
   (toggle-truncate-lines nil) 
   (org-indent-mode))
(add-hook 'org-mode-hook 'my-org-hook)

(defun detect-project-type (dir)
  (let ((makefile (file-exists-p (expand-file-name "Makefile" dir)))
	(pomfile (file-exists-p (expand-file-name "pom.xml" dir)))
	(antfile (file-exists-p (expand-file-name "build.xml" dir))))
    (cond 
     (makefile 'make)
     ((or pomfile antfile) 'java)
     (t (if (string= dir "/") 'none (detect-project-type (file-name-directory (directory-file-name dir))))))))

(defun my-compile-func ()
  (interactive)
  (let ((type (detect-project-type default-directory)))
    (cond
     ((eq type 'java) (java-compile))
     ((eq type 'make) (compile "make -k"))
     (t (error "Project type unknown")))))

(defun my-recompile-func ()
  (interactive)
  (let ((type (detect-project-type default-directory)))
    (cond
     ((eq type 'java) (java-recompile))
     ((eq type 'make) (compile "make -k"))
     (t (error "Project type unknown")))))

(defun kill-buffer-no-hooks () 
  (interactive)
  (let ((kill-buffer-hook nil)) 
    (kill-buffer)))

(global-set-key [(f10)] 'my-compile-func)
(global-set-key [(f11)] 'my-recompile-func)
