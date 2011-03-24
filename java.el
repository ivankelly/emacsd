
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

(defun ant-target ()
  (interactive)
  (compile (concat "ant -e -f " 
		   (ant-find-build-xml default-directory) " " (read-input "Target: "))))

(defun mvn-target ()
  (interactive)
  (compile (concat "mvn -f " 
		   (mvn-find-pom-xml default-directory) " " (read-input "Target: "))))

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
    (if (> (length (file-name-directory (if (null ant-file) "" ant-file)))
	   (length (file-name-directory (if (null mvn-file) "" mvn-file))))
	(compile (concat "ant -e -f " ant-file " compile "))
      (compile (concat "mvn -f " mvn-file " package")))
    ))

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


(autoload 'javadoc-lookup       "javadoc-help" "Look up Java class in Javadoc."   t)
(autoload 'javadoc-help         "javadoc-help" "Open up the Javadoc-help menu."   t)
(autoload 'javadoc-set-predefined-urls  "javadoc-help" "Set pre-defined urls."    t)
(global-set-key [(f1)]          'javadoc-lookup)  ; F1 to lookup
(global-set-key [(shift f1)]    'javadoc-help)    ; Shift-F1 to bring up men
(javadoc-set-predefined-urls 
 '("http://java.sun.com/j2se/1.6.0/docs/api/" 
   "http://hadoop.apache.org/common/docs/r0.20.1/api/" 
   "http://download.eclipse.org/jetty/stable-7/apidocs/" 
   "http://docs.jboss.org/netty/3.2/api/"
   "http://hc.apache.org/httpcomponents-client-ga/httpclient/apidocs/"
   "http://hbase.apache.org/apidocs/"
   "http://www.xbill.org/dnsjava/dnsjava-current/doc/"
   "http://hc.apache.org/httpcomponents-core-ga/httpcore/apidocs/"
   "http://junit.sourceforge.net/javadoc/"))
;(jdh-process-predefined-urls *jdh-predefined-urls*)

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
     ((= current (- (elt emacs 0) outer)) eclipse)
     ((= current eclipse) emacs)
     (t emacs))))

(defun ivan-lineup-arglist-intro (langelem)
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
  (c-set-offset 'arglist-intro 'ivan-lineup-arglist-intro))

(add-hook 'java-mode-hook 'set-c-offset)

(defvar java-debug-sourcepath nil)
(defun java-attach-debugger ()
  (interactive)
  (jdb (concat "jdb -attach 4444 -sourcepath" java-debug-sourcepath)))
