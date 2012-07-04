
(defun ant-build ()
  (interactive)
  (compile (concat "ant -e -f " (ant-find-build-xml default-directory) " build")))

(defun ant-compile ()
  (interactive)
  (compile (concat "ant -e -f " (ant-find-build-xml default-directory) " compile")))

(defun ant-clean ()
  (interactive)
  (compile (concat "ant -e -f "  (ant-find-build-xml default-directory) " clean")))

(defun ant-jar ()
  (interactive)
  (compile (concat "ant -e -f " (ant-find-build-xml default-directory) " jar")))

(defun ant-job ()
  (interactive)
  (compile (concat "ant -e -f " (ant-find-build-xml default-directory) " job")))

(defvar compile-target "")

(defun ant-target ()
  (interactive)
  (setq compile-target (read-input "Target: "))
  (compile (concat "ant -e -f " 
		   (ant-find-build-xml default-directory) " " compile-target)))

(defun mvn-target ()
  (interactive)
  (setq compile-target (read-input "Target: "))
  (compile (concat "mvn -f " 
		   (mvn-find-pom-xml default-directory) " " compile-target)))

(defun ant-find-build-xml (dir &optional nowarn)
  (let ((file (expand-file-name "build.xml" dir)))
    (if (file-exists-p file)
	file
      (if (string= dir "/")
	  (if (null nowarn) (error "There is no build.xml"))
	(ant-find-build-xml (file-name-directory (directory-file-name dir)) nowarn)))))

(defun mvn-find-pom-xml (dir &optional nowarn)
  (let ((file (expand-file-name "pom.xml" dir)))
    (if (file-exists-p file)
	file
      (if (string= dir "/")
	  (if (null nowarn) (error "There is no pom.xml"))
	(mvn-find-pom-xml (file-name-directory (directory-file-name dir)) nowarn)))))

(defun java-compile ()
  (let ((mvn-file (mvn-find-pom-xml default-directory t))
	(ant-file (ant-find-build-xml default-directory t)))
    (if (and (null mvn-file) (null ant-file)) (error "No ant nor maven file found"))
    (if (>= (length (file-name-directory (if (null ant-file) "" ant-file)))
	   (length (file-name-directory (if (null mvn-file) "" mvn-file))))
	(compile (concat "ant -e -f " ant-file " compile "))
      (compile (concat "mvn -f " mvn-file " package")))
    ))

(defun java-recompile () 
  (let ((mvn-file (mvn-find-pom-xml default-directory t))
	(ant-file (ant-find-build-xml default-directory t)))
    (if (and (null mvn-file) (null ant-file)) (error "No ant nor maven file found"))
    (if (>= (length (file-name-directory (if (null ant-file) "" ant-file)))
	    (length (file-name-directory (if (null mvn-file) "" mvn-file))))
	(compile (concat "ant -e -f " ant-file " " compile-target))
      (compile (concat "mvn -f " mvn-file " " compile-target)))
    )
  )

(require 'compile)
(add-to-list
 'compilation-error-regexp-alist
 '("^\\([/a-zA-Z\\.~_+-]*\\):\\[\\([0-9]+\\),\\([0-9]+\\)\\]" 1 2 3))
(add-to-list
 'compilation-error-regexp-alist
 '("^\\[ERROR\\] \\([/a-zA-Z\\.~_+-]*\\):\\[\\([0-9]+\\),\\([0-9]+\\)\\]" 1 2 3))


(defun jde-add-cp ()
  (interactive)
  (setq jde-global-classpath (append 
			      (let ((fn (expand-file-name (read-file-name "New Classpath: "))))
				(if (file-directory-p fn)
				    `(,fn)
				  (file-expand-wildcards fn)))
				     jde-global-classpath)))


(defun jde-edit-cp ()
  (interactive)
  (customize-variable 'jde-global-classpath))


(global-set-key [(f5)] 'gud-step)
(global-set-key [(f6)] 'gud-next)
(global-set-key [(f7)] 'gud-finish)
(global-set-key [(f8)] 'gud-cont)

(setq javadoc-help-setting-file (expand-file-name ".emacs.d/javadoc-source-list" "~"))
(require 'javadoc-help)

(global-set-key [(f1)]          'javadoc-lookup)  ; F1 to lookup
(global-set-key [(shift f1)]    'javadoc-help)    ; Shift-F1 to bring up men

(defun current-indent ()
  (let ((outerline (outerline-indent))
	(thisline (save-excursion
		    (beginning-of-line)
		    (c-forward-syntactic-ws)
		    (current-column))))
    (- thisline outerline)))

(defun outerline-indent ()
  (save-excursion
    (goto-char (c-langelem-2nd-pos c-syntactic-element))
    (beginning-of-line)
    (c-forward-syntactic-ws)
    (current-column)))

(defun ivan-lineup-arglist (langelem)
  (let ((current (current-indent))
	(outer (outerline-indent))
	(emacs (c-lineup-arglist langelem))
	(eclipse (* c-basic-offset 2)))
    (cond 
     ((= current (- (if (sequencep emacs) (elt emacs 0) emacs) outer)) eclipse)
     ((= current eclipse) emacs)
     (t emacs))))

(defun ivan-lineup-arglist-intro (langelem)
;;  (current-indent))
   (let ((current (current-indent))
  	(outer (outerline-indent))
  	(emacs (c-lineup-arglist-intro-after-paren langelem))
  	(eclipse (* c-basic-offset 2)))
    (cond
     ((= current (- (elt emacs 0) outer)) eclipse)
     ((= current eclipse) emacs)
     (t emacs))))

(defun set-c-offset ()
  (c-set-offset 'arglist-cont-nonempty 'ivan-lineup-arglist)
  (c-set-offset 'func-decl-cont '++)
  (c-set-offset 'arglist-intro 'ivan-lineup-arglist-intro)
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4)
  )

(add-hook 'java-mode-hook 'set-c-offset)
(add-hook 'java-mode-hook '(lambda () "Treat Java 1.5 @-style annotations as comments."
                             (setq c-comment-start-regexp  "\\(@\\|/\\(/\\|[*][*]?\\)\\)")
                             (modify-syntax-entry ?@ "< b" java-mode-syntax-table)))


(defun fixup-buffer-name ()
  (interactive)
  (if (string-match "/\\([^/]+\\)/pom.xml$" (buffer-file-name))
      (rename-buffer (concat "pom.xml [" (match-string 1 (buffer-file-name)) "]") t)))
(add-hook 'find-file-hook 'fixup-buffer-name)


(defvar java-debug-sourcepath nil)
(defun java-attach-debugger ()
  (interactive)
  (jdb (concat "jdb -attach 5005 -sourcepath" java-debug-sourcepath)))


(defun indent-all (dir) 
  (mapcar (lambda (f)
	    (if (file-directory-p f) 
		(indent-all f)
	      (if (string-match "\.java$" f)
		  (save-excursion
		    (find-file f)
		    (setq indent-tabs-mode nil)
		    (indent-region (point-min) (point-max))
		    (save-buffer)
		    (kill-buffer)))))
	  (directory-files dir t "^[^\.]")))

(defun disable-all-tests ()
  (interactive)
  (save-excursion
    (goto-char 1)
    (replace-string "public void test" "public void notest")
    (goto-char 1)
    (replace-string "@Test" "//@Test")))

(defun enable-all-tests ()
  (interactive)
  (save-excursion
    (goto-char 1)
    (replace-string "public void notest" "public void test")
    (goto-char 1)
    (replace-string "//@Test" "@Test")))
