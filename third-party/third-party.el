(setq load-path (cons (expand-file-name ".emacs.d/third-party" "~") load-path))

(setq load-path (cons (expand-file-name ".emacs.d/third-party/magit-1.0.0" "~") load-path))
(require 'magit)

(require 'session)
(add-hook 'after-init-hook 'session-initialize)


