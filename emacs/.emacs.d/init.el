;;; init.el --- forja-c — C IDE

;; Raíz del repo forja-c (2 niveles arriba de emacs/.emacs.d/)
(defvar my/forja-root
  (expand-file-name "../../" (file-name-directory (or load-file-name buffer-file-name))))

;; Nombre e identidad del IDE
(setq my/forja-ide-name "forja-c")

;; Directorios de módulos de extensión (orden: C-específicos, luego IA)
(setq my/forja-ext-dirs
  (delq nil
    (list
      (expand-file-name "emacs/.emacs.d/modules/" my/forja-root)
      (let ((d (expand-file-name "ai/modules/" my/forja-root)))
        (when (file-directory-p d) d)))))

;; Módulos que carga este IDE
(setq my/forja-ext-base-modules '("30-c"))

(setq my/forja-ext-lazy-modules
  (delq nil
    (list
      (when (file-directory-p (expand-file-name "ai/modules/" my/forja-root)) "33-aider")
      (when (file-directory-p (expand-file-name "ai/modules/" my/forja-root)) "57-opencode")
      (when (file-directory-p (expand-file-name "ai/modules/" my/forja-root)) "58-gemini")
      (when (file-directory-p (expand-file-name "ai/modules/" my/forja-root)) "59-claude"))))

;; Cargar forja-core
(load (expand-file-name "core/emacs/.emacs.d/init.el" my/forja-root))
