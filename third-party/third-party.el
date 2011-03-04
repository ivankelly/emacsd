(setq load-path (cons (expand-file-name ".emacs.d/third-party" "~") load-path))

(require 'session)
(add-hook 'after-init-hook 'session-initialize)


