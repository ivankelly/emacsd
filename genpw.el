(require 'sha1)

(defun genpw (seed)
  (interactive "sSeed: ")
  (substring (concat (delq nil 
			   (mapcar (lambda (x) (let ((c (logand x 127)))
						 (if (and (> 126 c) (< 33 c)) c nil)))
		   (string-to-list (sha1-binary seed))))) 0 10))

(defun genpw-to-clipboard (seed)
  (interactive "sSeed: ")
  (let (( x-select-enable-clipboard t))
    (x-select-text (genpw seed))))

