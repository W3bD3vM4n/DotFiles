;;; early-init.el -*- lexical-binding: t; -*-
;;; Commentary:
;;
;; Emacs 27.1 introduced early-init.el, which is run before init.el, before
;; package and UI initialization happens, and before site files are loaded. This
;; is the best time to make all our changes (though any UI work will have to be
;; deferred).
;;
;; This file is the entry point into Doom Emacs for your standard, interactive
;; Emacs session, and houses our most pressing and hackiest startup
;; optimizations. That said, only the "bootstrap" section at the bottom is
;; required for Doom to function.
;;
;;; Code:

;; A big contributor to startup times is garbage collection. We up the gc
;; threshold to temporarily prevent it from running, then reset it later by
;; enabling `gcmh-mode'. Not resetting it will cause stuttering/freezes.
(setq gc-cons-threshold most-positive-fixnum)

;; In noninteractive sessions, prioritize non-byte-compiled source files to
;; prevent the use of stale byte-code. Otherwise, it saves us a little IO time
;; to skip the mtime checks on every *.elc file.
(setq load-prefer-newer noninteractive)

(unless (or (daemonp)
            noninteractive
            init-file-debug)
  (let ((old-file-name-handler-alist file-name-handler-alist))
    ;; `file-name-handler-alist' is consulted on each `require', `load' and
    ;; various path/io functions. You get a minor speed up by unsetting this.
    ;; Some warning, however: this could cause problems on builds of Emacs where
    ;; its site lisp files aren't byte-compiled and we're forced to load the
    ;; *.el.gz files (e.g. on Alpine).
    (setq-default file-name-handler-alist nil)
    ;; ...but restore `file-name-handler-alist' later, because it is needed for
    ;; handling encrypted or compressed files, among other things.
    (defun doom-reset-file-handler-alist-h ()
      (setq file-name-handler-alist
            ;; Merge instead of overwrite because there may have bene changes to
            ;; `file-name-handler-alist' since startup we want to preserve.
            (delete-dups (append file-name-handler-alist
                                 old-file-name-handler-alist))))
    (add-hook 'emacs-startup-hook #'doom-reset-file-handler-alist-h 101))

  ;; Premature redisplays can substantially affect startup times and produce
  ;; ugly flashes of unstyled Emacs.
  (setq-default inhibit-redisplay t
                inhibit-message t)
  (add-hook 'window-setup-hook
            (lambda ()
              (setq-default inhibit-redisplay nil
                            inhibit-message nil)
              (redisplay)))

  ;; Site files tend to use `load-file', which emits "Loading X..." messages in
  ;; the echo area, which in turn triggers a redisplay. Redisplays can have a
  ;; substantial effect on startup times and in this case happens so early that
  ;; Emacs may flash white while starting up.
  (define-advice load-file (:override (file) silence)
    (load file nil 'nomessage))

  ;; Undo our `load-file' advice above, to limit the scope of any edge cases it
  ;; may introduce down the road.
  (define-advice startup--load-user-init-file (:before (&rest _) init-doom)
    (advice-remove #'load-file #'load-file@silence)))


;;
;;; Bootstrap

;; Ensure Doom is running out of this file's directory
(setq user-emacs-directory (file-name-directory load-file-name))

;; Load the heart of Doom Emacs
(load (concat user-emacs-directory "core/core") nil 'nomessage)

;; We hijack Emacs' initfile resolver to inject our own entry point. Why do
;; this? Because:
;;
;; - It spares Emacs the effort of looking for/loading useless initfiles, like
;;   ~/.emacs and ~/_emacs. And skips ~/.emacs.d/init.el, which won't exist if
;;   you're using Doom (fyi: doom hackers or chemacs users could then use
;;   $EMACSDIR as their $DOOMDIR, if they wanted).
;; - Later, 'doom sync' will dynamically generate its bootstrap file, which is
;;   important for Doom's soon-to-be profile system (which can replace Chemacs).
;;   Until then, we'll use core/core-start.el.
;; - A "fallback" initfile can be trivially specified, in case the bootstrapper
;;   is missing (if the user hasn't run 'doom sync' or is a first-timer). This
;;   is an opportunity to display a "safe mode" environment that's less
;;   intimidating and more helpful than the broken state errors would've left
;;   Emacs in, otherwise.
;; - A generated config allows for a file IO optimized startup.
(define-advice startup--load-user-init-file (:filter-args (args) init-doom)
  "Initialize Doom Emacs in an interactive session."
  (list (lambda ()
          (expand-file-name "core-start" doom-core-dir))
        nil  ; TODO Replace with safe mode initfile
        (caddr args)))

;;; early-init.el ends here

;;; Maximize Emacs on startup
(defun maximize-frame ()
  "Maximizes the active frame in Windows"
  (interactive)
  ;; Send a `WM_SYSCOMMAND' message to the active frame with the
  ;; `SC_MAXIMIZE' parameter.
  (when (eq system-type 'windows-nt)
    (w32-send-sys-command 61488)))
(add-hook 'window-setup-hook 'maximize-frame t)