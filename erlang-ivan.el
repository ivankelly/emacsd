(defun erlang-shell-code-add-path (path)
  (interactive "DEBin Directory: ")
  (inferior-erlang-send-command (concat "code:add_path(\"" (expand-file-name path) "\").")))

(defun erlang-shell-code-add-paths (glob) 
  (interactive "GEBin Glob: ")
  (mapcar 'erlang-shell-code-add-path (file-expand-wildcards glob)))

