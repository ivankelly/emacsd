(defun find-prj.el (dir) 
  (let ((file (expand-file-name "prj.el" dir)))
    (if (file-exists-p file)
    file
      (if (string= dir "/") 
      nil
    (find-prj.el (file-name-directory 
              (directory-file-name dir)))))))

(defun find-prj-hook ()
  (let ((file (find-prj.el (file-name-directory buffer-file-name))))
    (if file
    (load-file file))))

(add-hook 'java-mode-hook 'find-prj-hook t)
(add-hook 'erlang-mode-hook 'find-prj-hook t)
(add-hook 'nxml-mode-hook 'find-prj-hook t)



