;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here
(setq doom-font (font-spec :family "Fira Mono" :size 14))
(load-theme 'doom-gruvbox t)
;; (setq doom-font (font-spec :family "Monaco" :size 14))

(setq confirm-kill-emacs nil)

(setq select-enable-clipboard nil)
(fset 'evil-visual-update-x-selection 'ignore)

;; Set "SPC SPC" for M-x
(map! :leader :n "SPC" 'execute-extended-command)
(global-set-key "\C-x\C-m" 'execute-extended-command)

;;;;;;;;;;;;;;;;;;;;;;;;
;;  markdown config   ;;
;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'markdown-mode-hook 'pandoc-mode)
(add-hook 'pandoc-mode-hook 'pandoc-load-default-settings)
(setq markdown-split-window-direction 'right)
(setq markdown-command
      (concat
       "/usr/local/bin/pandoc"
       " --from=markdown --to=html"
       " --standalone --mathjax --highlight-style=pygments"))
(add-hook 'markdown-mode-hook #'visual-line-mode)
(add-hook 'markdown-mode-hook #'abbrev-mode)
(add-hook 'markdown-mode-hook 'turn-off-auto-fill)

;; define markdown-mode-map
(map! :map markdown-mode-map
      :localleader
      :nv "i b" 'markdown-insert-bold
      :n "i f" 'markdown-insert-image)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; latex mode config    ;; ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq TeX-save-query nil)
(add-hook 'latex-mode-hook (lambda()
                             (setq buffer-save-without-query t)))
(add-hook 'latex-mode-hook #'hl-todo-mode)
(add-hook 'latex-mode-hook #'turn-off-auto-fill)
(add-hook 'latex-mode-hook #'abbrev-mode)
(map! :map LaTeX-mode-map
      :localleader
      :n  "/ /" 'indent-for-tab-command
      :nv "p c b" 'preview-clearout-buffer
      :nv "p c p" 'preview-clearout-at-point
      :nv "p c s" 'preview-clearout-section
      :nv "p r" 'preview-region
      :nv "p b" 'preview-buffer
      :nv "p s" 'preview-section
      :nv "m s" 'LaTeX-mark-section
      :nv "m e" 'LaTeX-mark-environment
      :n  "c" 'TeX-command-master)

(set-default 'preview-scale-function 1.8)

(setq yas-triggers-in-field t)

;;;;;;;;;;;;;;;;;
;; evil config ;;
;;;;;;;;;;;;;;;;;
(setq avy-single-candidate-jump t)

;; solve the map conflict with company select next and previous
(define-key evil-insert-state-map (kbd "C-n") nil)
(define-key evil-insert-state-map (kbd "C-p") nil)

;; make evil insert mode map like emacs
(map! :i "C-f" 'forward-char)
(map! :leader :n "yy" 'clipboard-yank)
(map! :i "C-b" 'backward-char)
(map! :leader :nv "ii" 'evil-numbers/inc-at-pt)
(map! :leader :nv "id"'evil-numbers/dec-at-pt)
(map! :nv "j" 'evil-next-visual-line)
(map! :nv "k" 'evil-previous-visual-line)
(map! :iv "C-l" 'up-list)
(map! :i  "C-k" 'kill-line)
(map! :ne "M-/" #'comment-or-uncomment-region)
(map! :ne "C-;" #'avy-goto-char-2)
(map! :ni "M-c" #'clipboard-kill-region)
(map! :ni "M-v" #'clipboard-yank)
(map! :ni "M-z" #'undo-tree-undo)
(map! :ni "M-Z" #'undo-tree-redo)
(define-key minibuffer-local-map (kbd "M-v") 'clipboard-yank)

(add-hook 'after-save-hook #'delete-trailing-whitespace)

(global-evil-matchit-mode 1)

;; (evil-set-initial-state 'eshell-mode 'emacs)

;; company config
(after! company-backends
  (setq company-idle-delay 0.3
        company-minimum-prefix-length 1
        company-transformers nil)
  (setq company-show-numbers t)
  (define-key! company-active-map
    (kbd "C-n") #'company-select-next
    (kbd "C-p")) #'company-select-previous)


;;;;;;;;;;;;;;;;;;;;;;
;;  python config   ;;
;;;;;;;;;;;;;;;;;;;;;;

(require 'py-autopep8)

(setenv "WORKON_HOME" "/Users/travis/opt/anaconda3/envs")

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-")

;;;;;;;;;;;;;;;;;;;
;; matlab config ;;
;;;;;;;;;;;;;;;;;;;
(autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
(add-to-list
  'auto-mode-alist
  '("\\.m$" . matlab-mode))
(setq matlab-shell-command "/Applications/MATLAB_R2020a.app/bin/matlab")
(setq matlab-shell-command-switches (list "-nodesktop"))

;; substitute y with enter
(defun y-or-n-p-with-return (orig-func &rest args)
  (let ((query-replace-map (copy-keymap query-replace-map)))
    (define-key query-replace-map (kbd "RET") 'act)
    (apply orig-func args)))

(advice-add 'y-or-n-p :around #'y-or-n-p-with-return)

;; make dired mode auto update when files change
(add-hook 'dired-mode-hook 'auto-revert-mode)

(setq mac-command-modifier 'meta)

(setq mac-option-modifier 'super)

;; ispell dictionary add new word silently
(setq ispell-silently-savep t)
(defun my-save-word ()
  (interactive)
  (let ((current-location (point))
         (word (flyspell-get-word)))
    (when (consp word)
      (flyspell-do-correct 'save nil (car word) current-location (cadr word) (caddr word) current-location))))
(map! :leader :n "/ w" #'my-save-word)

(setq org-directory "~/OneDrive - CUHK-Shenzhen/Notes/")

(after! org
  (map! (:map org-mode-map
        ;; :leader "/ s" #'org-sparse-tree
        ;; :leader "/ t" #'org-tags-sparse-tree
        :n "M-j" #'org-metadown
        :n "M-k" #'org-metaup))
  (add-hook! 'org-mode-hook (lambda ()
                            (setq truncate-lines t))
             'org-after-todo-statistics-hook 'org-summary-todo)
  (setq
        org-agenda-files "~/OneDrive - CUHK-Shenzhen/Notes/todo.org"
        org-agenda-window-setup 'other-window
        org-agenda-start-on-weekday 1
        org-log-done 'time
        org-log-repeat 'note
        org-agenda-skip-deadline-if-done t
        org-agenda-skip-scheduled-if-done t
        org-log-into-drawer t
        ))

;;;;;;;;;;;
;; alias ;;
;;;;;;;;;;;

(defalias 'wko 'pyvenv-workon)
(defalias 'nf 'new-frame)
(defalias 'cg 'customize-group)
(defalias 'cv 'customize-variable)
(defalias 'yvs 'yas-visit-snippet-file)
(defalias 'yis 'yas/insert-snippet)
(defalias 'pcb 'preview-clearout-buffer)
(defalias 'pb  'preview-buffer)
(defalias 'ima 'inverse-add-mode-abbrev)
(defalias 'iga 'inverse-add-global-abbrev)

(defun sqlparse-region (beg end)
  (interactive "r")
  (shell-command-on-region

   beg end
   "python -c 'import sys, sqlparse; print(sqlparse.format(sys.stdin.read(), reindent=True))'"
   t t))
