(setq load-path (cons (expand-file-name ".emacs.d" "~") load-path))

(load-file (expand-file-name ".emacs.d/third-party/third-party.el" "~"))

(tool-bar-mode -1)
(menu-bar-mode -1)
(iswitchb-mode t)

(put 'narrow-to-region 'disabled nil)
(setq vc-handled-backends nil)

(load-library "grep-source")
(load-library "java")
(load-library "misc")
(load-library "project")
(load-library "erlang-ivan")
(load-library "genpw")

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(confirm-kill-emacs (quote y-or-n-p)))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(diff-file-header ((((class color) (min-colors 88) (background dark)) (:background "grey60" :foreground "black" :weight bold))))
 '(magit-item-highlight ((((class color) (background dark)) (:background "black"))))
 '(org-level-2 ((t (:inherit outline-2 :foreground "yellow")))))

(show-paren-mode)
(global-set-key [home] 'beginning-of-line)
(global-set-key [end] 'end-of-line)
(global-unset-key "\C-z")

(setq indent-tabs-mode nil)
(setq show-trailing-whitespace t)

(let ((fn (expand-file-name "~/.emacs.d/local.el")))
  (if (file-exists-p fn)
    (load-file fn)))

