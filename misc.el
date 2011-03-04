
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

(defun my-compile-func ()
  (interactive)
  (if (or (eq major-mode 'sgml-mode)
	  (eq major-mode 'jde-mode)
	  (eq major-mode 'java-mode))
      (java-compile)
    (compile "make -k")))

(global-set-key [(f10)] 'my-compile-func)
