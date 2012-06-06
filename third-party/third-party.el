(setq load-path (cons (expand-file-name ".emacs.d/third-party" "~") load-path))

(let ((magit-emacs (expand-file-name ".emacs.d/third-party/magit" "~")))
  (if (file-directory-p magit-emacs)
      (progn
	(setq load-path (cons magit-emacs load-path))
	(require 'magit)
	(require 'magit-svn))))

(require 'session)
(add-hook 'after-init-hook 'session-initialize)

(setq load-path (cons (expand-file-name ".emacs.d/third-party/emacs-color-theme-solarized/" "~") load-path))

;(let ((distel-emacs (expand-file-name ".emacs.d/third-party/distel/elisp" "~")))
;  (if (file-directory-p distel-emacs)
;      (progn
;	(setq load-path (cons distel-emacs load-path))
;	(require 'distel)
;	(distel-setup))))





